import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_service.dart';
import '../services/local_service.dart';
import '../services/cache_service.dart';
import '../services/reward_service.dart';
import '../models/lesson_model.dart';
import '../models/quiz_result_model.dart';

class LessonProvider with ChangeNotifier {
  final Map<int, List<LessonModel>> _unitLessons = {}; // دروس مقسمة حسب الوحدة
  final Map<String, LessonModel> _loadedLessons = {}; // دروس محملة في الذاكرة
  final Set<int> _loadedUnits = {}; // الوحدات المحملة
  final Set<int> _loadingUnits = {}; // الوحدات قيد التحميل
  final Map<String, DateTime> _lessonAccessTime = {}; // وقت آخر وصول للدرس
  
  List<LessonModel> _localLessons = [];
  LessonModel? _currentLesson;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasNetworkConnection = true;
  DateTime? _lastCacheUpdate;
  
  // تتبع محلي للاختبارات المكتملة فقط (بدون XP/Gems منفصلة)
  Set<String> _localCompletedQuizzes = {};

  // إعدادات إدارة الذاكرة
  static const int _maxLoadedLessons = 20; // الحد الأقصى للدروس في الذاكرة
  static const int _maxLoadedUnits = 3; // الحد الأقصى للوحدات المحملة
  static const Duration _lessonCacheTimeout = Duration(minutes: 30); // مهلة انتهاء الدرس في الذاكرة

  List<LessonModel> get lessons => _getAllLoadedLessons();
  List<LessonModel> get localLessons => _localLessons;
  LessonModel? get currentLesson => _currentLesson;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasNetworkConnection => _hasNetworkConnection;
  
  Set<int> get loadedUnits => Set.from(_loadedUnits);
  Set<int> get loadingUnits => Set.from(_loadingUnits);
  int get totalLoadedLessons => _loadedLessons.length;

  /// الحصول على جميع الدروس المحملة
  List<LessonModel> _getAllLoadedLessons() {
    final allLessons = <LessonModel>[];
    allLessons.addAll(_localLessons);
    allLessons.addAll(_loadedLessons.values);
    
    // إزالة التكرارات
    final uniqueLessons = <String, LessonModel>{};
    for (var lesson in allLessons) {
      uniqueLessons[lesson.id] = lesson;
    }
    
    final result = uniqueLessons.values.toList();
    result.sort((a, b) {
      if (a.unit != b.unit) return a.unit.compareTo(b.unit);
      return a.order.compareTo(b.order);
    });
    
    return result;
  }

  /// تحميل فوري للدروس مع أولوية للمحتوى المحلي والتحميل التدريجي
  Future<void> loadLessons({int? unit, bool forceRefresh = false}) async {
    try {
      _setLoading(true);
      _clearError();
      
      // المرحلة 1: تحميل الدروس المحلية فوراً (أولوية قصوى)
      await _loadLocalLessonsInstantly(unit: unit);
      
      // المرحلة 2: تحميل الوحدة المطلوبة أو الوحدة الحالية
      final targetUnit = unit ?? _determineCurrentUnit();
      await _loadUnitProgressively(targetUnit, forceRefresh: forceRefresh);
      
      // المرحلة 3: تحميل مسبق للوحدة التالية في الخلفية
      _preloadNextUnit(targetUnit);
      
      // المرحلة 4: تنظيف الذاكرة
      await _cleanupMemory();
      
    } catch (e) {
      _setError('فشل في تحميل الدروس');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل وحدة معينة بشكل تدريجي
  Future<void> _loadUnitProgressively(int unit, {bool forceRefresh = false}) async {
    if (_loadingUnits.contains(unit)) return; // تجنب التحميل المتكرر
    
    try {
      _loadingUnits.add(unit);
      
      // التحقق من وجود الوحدة في الكاش
      if (!forceRefresh && _loadedUnits.contains(unit)) {
        print('✅ الوحدة $unit محملة مسبقاً');
        return;
      }
      
      // تحميل من الكاش أولاً
      final cachedLessons = await CacheService.getCachedLessons(
        unit: unit, 
        prioritizeUnit: true
      );
      
      if (cachedLessons.isNotEmpty && await CacheService.isCacheValid()) {
        _unitLessons[unit] = cachedLessons;
        _loadedUnits.add(unit);
        
        // إضافة للدروس المحملة
        for (var lesson in cachedLessons) {
          _loadedLessons[lesson.id] = lesson;
          _lessonAccessTime[lesson.id] = DateTime.now();
        }
        
        notifyListeners();
        print('✅ تم تحميل الوحدة $unit من الكاش (${cachedLessons.length} دروس)');
      }
      
      // تحميل من Firebase في الخلفية
      _loadUnitFromFirebaseInBackground(unit);
      
    } catch (e) {
      print('❌ خطأ في تحميل الوحدة $unit: $e');
    } finally {
      _loadingUnits.remove(unit);
    }
  }

  /// تحميل وحدة من Firebase في الخلفية
  Future<void> _loadUnitFromFirebaseInBackground(int unit) async {
    try {
      _hasNetworkConnection = await FirebaseService.checkConnection()
          .timeout(const Duration(seconds: 2), onTimeout: () => false);
      
      if (!_hasNetworkConnection) return;
      
      final firebaseLessons = await FirebaseService.getLessons(unit: unit)
          .timeout(const Duration(seconds: 10), onTimeout: () => <LessonModel>[]);
      
      if (firebaseLessons.isNotEmpty) {
        _unitLessons[unit] = firebaseLessons;
        _loadedUnits.add(unit);
        
        // تحديث الدروس المحملة
        for (var lesson in firebaseLessons) {
          _loadedLessons[lesson.id] = lesson;
          _lessonAccessTime[lesson.id] = DateTime.now();
        }
        
        // حفظ في الكاش
        await CacheService.updateCachePartially(firebaseLessons);
        
        notifyListeners();
        print('✅ تم تحميل الوحدة $unit من Firebase (${firebaseLessons.length} دروس)');
      }
      
    } catch (e) {
      print('❌ خطأ في تحميل الوحدة $unit من Firebase: $e');
    }
  }

  /// تحديد الوحدة الحالية للمستخدم
  int _determineCurrentUnit() {
    final allCompletedQuizzes = <String>{};
    allCompletedQuizzes.addAll(_localCompletedQuizzes);
    
    // البحث في الوحدات المحملة
    final availableUnits = _unitLessons.keys.toList()..sort();
    
    for (int unit in availableUnits) {
      final unitLessons = _unitLessons[unit] ?? [];
      final completedInUnit = unitLessons.where((l) => allCompletedQuizzes.contains(l.id)).length;
      
      if (completedInUnit < unitLessons.length) {
        return unit;
      }
    }
    
    return availableUnits.isNotEmpty ? availableUnits.last + 1 : 1;
  }

  /// تحميل مسبق للوحدة التالية
  void _preloadNextUnit(int currentUnit) {
    final nextUnit = currentUnit + 1;
    
    // تحميل في الخلفية بدون انتظار
    Future.delayed(const Duration(seconds: 2), () {
      if (!_loadedUnits.contains(nextUnit) && !_loadingUnits.contains(nextUnit)) {
        _loadUnitProgressively(nextUnit);
      }
    });
  }

  /// تنظيف الذاكرة من الدروس والوحدات غير المستخدمة
  Future<void> _cleanupMemory() async {
    try {
      final now = DateTime.now();
      
      // تنظيف الدروس القديمة
      final expiredLessons = <String>[];
      for (var entry in _lessonAccessTime.entries) {
        if (now.difference(entry.value) > _lessonCacheTimeout) {
          expiredLessons.add(entry.key);
        }
      }
      
      for (var lessonId in expiredLessons) {
        _loadedLessons.remove(lessonId);
        _lessonAccessTime.remove(lessonId);
      }
      
      // تنظيف الوحدات الزائدة
      if (_loadedUnits.length > _maxLoadedUnits) {
        final sortedUnits = _loadedUnits.toList()..sort();
        final unitsToRemove = sortedUnits.take(_loadedUnits.length - _maxLoadedUnits);
        
        for (var unit in unitsToRemove) {
          final unitLessons = _unitLessons[unit] ?? [];
          for (var lesson in unitLessons) {
            _loadedLessons.remove(lesson.id);
            _lessonAccessTime.remove(lesson.id);
          }
          _unitLessons.remove(unit);
          _loadedUnits.remove(unit);
        }
      }
      
      // تنظيف الدروس الزائدة
      if (_loadedLessons.length > _maxLoadedLessons) {
        final sortedLessons = _lessonAccessTime.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));
        
        final lessonsToRemove = sortedLessons
            .take(_loadedLessons.length - _maxLoadedLessons)
            .map((e) => e.key);
        
        for (var lessonId in lessonsToRemove) {
          _loadedLessons.remove(lessonId);
          _lessonAccessTime.remove(lessonId);
        }
      }
      
      if (expiredLessons.isNotEmpty || _loadedLessons.length > _maxLoadedLessons) {
        print('🧹 تم تنظيف الذاكرة: ${expiredLessons.length} دروس منتهية الصلاحية');
      }
      
    } catch (e) {
      print('❌ خطأ في تنظيف الذاكرة: $e');
    }
  }

  /// تحميل الدروس المحلية فوراً
  Future<void> _loadLocalLessonsInstantly({int? unit}) async {
    try {
      _localLessons = await LocalService.getLocalLessons(unit: unit);
      
      // إضافة للدروس المحملة
      for (var lesson in _localLessons) {
        _loadedLessons[lesson.id] = lesson;
        _lessonAccessTime[lesson.id] = DateTime.now();
        
        // تجميع حسب الوحدة
        _unitLessons.putIfAbsent(lesson.unit, () => []).add(lesson);
        _loadedUnits.add(lesson.unit);
      }
      
      // تحميل التقدم المحلي
      await _loadLocalProgress();
      
      // إشعار فوري لعرض الدروس
      notifyListeners();
      
    } catch (e) {
      _localLessons = [];
    }
  }

  /// الحصول على الدروس المتاحة بناءً على نظام الوحدات - مع التحميل التدريجي
  List<LessonModel> getAvailableLessons(List<String> completedQuizzes, int currentUnit) {
    // التأكد من تحميل الوحدة المطلوبة
    if (!_loadedUnits.contains(currentUnit)) {
      _loadUnitProgressively(currentUnit);
      return []; // إرجاع قائمة فارغة حتى يتم التحميل
    }
    
    final unitLessons = _unitLessons[currentUnit] ?? [];
    if (unitLessons.isEmpty) return [];
    
    // دمج الاختبارات المكتملة مع التقدم المحلي
    final allCompletedQuizzes = <String>{};
    allCompletedQuizzes.addAll(completedQuizzes);
    allCompletedQuizzes.addAll(_localCompletedQuizzes);
    
    // ترتيب الدروس حسب الترتيب
    unitLessons.sort((a, b) => a.order.compareTo(b.order));
    
    return unitLessons;
  }

  /// الحصول على معلومات الوحدات للعرض - مع دعم التحميل التدريجي
  List<UnitInfo> getUnitsInfo(List<String> completedQuizzes) {
    final allCompletedQuizzes = <String>{};
    allCompletedQuizzes.addAll(completedQuizzes);
    allCompletedQuizzes.addAll(_localCompletedQuizzes);
    
    final availableUnits = _unitLessons.keys.toList()..sort();
    final unitsInfo = <UnitInfo>[];
    
    for (int unit in availableUnits) {
      final unitLessons = _unitLessons[unit] ?? [];
      final completedCount = unitLessons.where((l) => allCompletedQuizzes.contains(l.id)).length;
      final isCompleted = completedCount == unitLessons.length;
      final isUnlocked = unit == 1 || (unit > 1 && unitsInfo.isNotEmpty && unitsInfo.last.isCompleted);
      final isLoaded = _loadedUnits.contains(unit);
      final isLoading = _loadingUnits.contains(unit);
      
      // تحديد حالة كل درس
      final lessonsWithStatus = unitLessons.map((lesson) {
        // تحديث وقت الوصول
        _lessonAccessTime[lesson.id] = DateTime.now();
        
        LessonStatus status;
        if (lesson.unit == 1 && lesson.order == 1) {
          status = LessonStatus.open;
        } else if (allCompletedQuizzes.contains(lesson.id)) {
          status = LessonStatus.completed;
        } else {
          final previousLesson = _getPreviousLesson(lesson);
          if (previousLesson == null || allCompletedQuizzes.contains(previousLesson.id)) {
            status = LessonStatus.open;
          } else {
            status = LessonStatus.locked;
          }
        }
        
        return LessonWithStatus(lesson: lesson, status: status);
      }).toList();
      
      unitsInfo.add(UnitInfo(
        unit: unit,
        title: _getUnitTitle(unit),
        totalLessons: unitLessons.length,
        completedLessons: completedCount,
        isCompleted: isCompleted,
        isUnlocked: isUnlocked,
        isLoaded: isLoaded,
        isLoading: isLoading,
        lessons: unitLessons,
        lessonsWithStatus: lessonsWithStatus,
      ));
    }
    
    return unitsInfo;
  }

  /// تحميل درس معين مع أولوية للمحتوى المحلي والتحميل الذكي
  Future<void> loadLesson(String lessonId, String userId) async {
    try {
      print('🚀 بدء تحميل الدرس: $lessonId للمستخدم: $userId');
      _setLoading(true);
      _clearError();
      
      // البحث في الدروس المحملة أولاً
      if (_loadedLessons.containsKey(lessonId)) {
        _currentLesson = _loadedLessons[lessonId];
        _lessonAccessTime[lessonId] = DateTime.now(); // تحديث وقت الوصول
        print('✅ تم العثور على الدرس في الذاكرة: ${_currentLesson!.title}');
        notifyListeners();
        return;
      }
      
      // البحث في الدروس المحلية
      print('🔍 البحث في الدروس المحلية...');
      _currentLesson = await LocalService.getLocalLesson(lessonId);
      
      if (_currentLesson != null) {
        print('✅ تم العثور على الدرس محلياً: ${_currentLesson!.title}');
        
        // إضافة للذاكرة
        _loadedLessons[lessonId] = _currentLesson!;
        _lessonAccessTime[lessonId] = DateTime.now();
      } else {
        print('⚠️ لم يتم العثور على الدرس محلياً، البحث في Firebase...');
        
        // البحث في Firebase
        _currentLesson = await FirebaseService.getLesson(lessonId);
        
        if (_currentLesson != null) {
          print('✅ تم العثور على الدرس في Firebase: ${_currentLesson!.title}');
          
          // إضافة للذاكرة والكاش
          _loadedLessons[lessonId] = _currentLesson!;
          _lessonAccessTime[lessonId] = DateTime.now();
          await CacheService.cacheLesson(_currentLesson!);
        } else {
          print('❌ لم يتم العثور على الدرس في أي مكان');
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('❌ خطأ في تحميل الدرس: $e');
      _setError('فشل في تحميل الدرس: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل وحدة معينة عند الطلب
  Future<void> loadUnit(int unit, {bool forceRefresh = false}) async {
    await _loadUnitProgressively(unit, forceRefresh: forceRefresh);
  }

  /// إلغاء تحميل وحدة معينة لتوفير الذاكرة
  Future<void> unloadUnit(int unit) async {
    try {
      final unitLessons = _unitLessons[unit] ?? [];
      
      // إزالة دروس الوحدة من الذاكرة
      for (var lesson in unitLessons) {
        _loadedLessons.remove(lesson.id);
        _lessonAccessTime.remove(lesson.id);
      }
      
      _unitLessons.remove(unit);
      _loadedUnits.remove(unit);
      
      notifyListeners();
      print('🗑️ تم إلغاء تحميل الوحدة $unit من الذاكرة');
    } catch (e) {
      print('❌ خطأ في إلغاء تحميل الوحدة $unit: $e');
    }
  }

  /// الحصول على إحصائيات الذاكرة
  MemoryStats getMemoryStats() {
    return MemoryStats(
      loadedLessons: _loadedLessons.length,
      loadedUnits: _loadedUnits.length,
      loadingUnits: _loadingUnits.length,
      localLessons: _localLessons.length,
      maxLoadedLessons: _maxLoadedLessons,
      maxLoadedUnits: _maxLoadedUnits,
    );
  }

  /// الحصول على الدرس السابق
  LessonModel? _getPreviousLesson(LessonModel lesson) {
    final unitLessons = _unitLessons[lesson.unit] ?? [];
    unitLessons.sort((a, b) => a.order.compareTo(b.order));
    
    final currentIndex = unitLessons.indexWhere((l) => l.id == lesson.id);
    if (currentIndex > 0) {
      return unitLessons[currentIndex - 1];
    }
    
    // إذا كان أول درس في الوحدة، فحص آخر درس في الوحدة السابقة
    if (lesson.unit > 1) {
      final previousUnitLessons = _unitLessons[lesson.unit - 1] ?? [];
      if (previousUnitLessons.isNotEmpty) {
        previousUnitLessons.sort((a, b) => a.order.compareTo(b.order));
        return previousUnitLessons.last;
      }
    }
    
    return null;
  }

  /// الحصول على عنوان الوحدة
  String _getUnitTitle(int unit) {
    switch (unit) {
      case 1:
        return 'أساسيات Python';
      case 2:
        return 'البرمجة المتقدمة';
      case 3:
        return 'المشاريع العملية';
      default:
        return 'الوحدة $unit';
    }
  }

  /// تسجيل إكمال الاختبار محلياً (بدون حساب مكافآت)
  Future<void> markQuizCompletedLocally(String lessonId) async {
    try {
      _localCompletedQuizzes.add(lessonId);
      await _saveLocalProgress();
      notifyListeners();
      
      print('✅ تم تسجيل إكمال الاختبار محلياً: $lessonId');
    } catch (e) {
      print('❌ خطأ في تسجيل إكمال الاختبار محلياً: $e');
    }
  }

  /// حفظ نتيجة الاختبار في Firebase
  Future<void> saveQuizResult(String userId, String lessonId, QuizResultModel result) async {
    try {
      await FirebaseService.saveQuizResult(userId, lessonId, result);
      
      // تسجيل الإكمال محلياً
      await markQuizCompletedLocally(lessonId);
      
      // مزامنة مع Firebase في الخلفية
      _syncQuizCompletionWithFirebase(userId, lessonId);
    } catch (e) {
      print('❌ خطأ في حفظ نتيجة الاختبار: $e');
    }
  }

  /// حفظ التقدم المحلي (الاختبارات المكتملة فقط)
  Future<void> _saveLocalProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('local_completed_quizzes', _localCompletedQuizzes.toList());
    } catch (e) {
      print('❌ خطأ في حفظ التقدم المحلي: $e');
    }
  }

  /// تحميل التقدم المحلي (الاختبارات المكتملة فقط)
  Future<void> _loadLocalProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedQuizzes = prefs.getStringList('local_completed_quizzes') ?? [];
      _localCompletedQuizzes = completedQuizzes.toSet();
    } catch (e) {
      print('❌ خطأ في تحميل التقدم المحلي: $e');
      _localCompletedQuizzes = {};
    }
  }

  /// مزامنة إكمال الاختبار مع Firebase (بدون حساب مكافآت)
  Future<void> _syncQuizCompletionWithFirebase(String userId, String lessonId) async {
    if (!_hasNetworkConnection) return;
    
    try {
      // تحديث قائمة الدروس المكتملة في Firebase
      await FirebaseService.updateUserData(userId, {
        'completedLessons': FieldValue.arrayUnion([lessonId]),
      }).timeout(const Duration(seconds: 10));
      
      // إزالة من القائمة المحلية بعد المزامنة الناجحة
      _localCompletedQuizzes.remove(lessonId);
      await _saveLocalProgress();
      
      print('🔄 تم مزامنة إكمال الاختبار مع Firebase: $lessonId');
    } catch (e) {
      print('⚠️ فشل في مزامنة إكمال الاختبار مع Firebase: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

/// معلومات الوحدة للعرض - مع دعم التحميل التدريجي
class UnitInfo {
  final int unit;
  final String title;
  final int totalLessons;
  final int completedLessons;
  final bool isCompleted;
  final bool isUnlocked;
  final bool isLoaded; // إضافة حالة التحميل
  final bool isLoading; // إضافة حالة التحميل الجاري
  final List<LessonModel> lessons;
  final List<LessonWithStatus> lessonsWithStatus;

  UnitInfo({
    required this.unit,
    required this.title,
    required this.totalLessons,
    required this.completedLessons,
    required this.isCompleted,
    required this.isUnlocked,
    required this.isLoaded, // إضافة المعامل الجديد
    required this.isLoading, // إضافة المعامل الجديد
    required this.lessons,
    required this.lessonsWithStatus,
  });

  double get progress => totalLessons > 0 ? completedLessons / totalLessons : 0.0;
}

/// حالة الدرس
enum LessonStatus {
  open,      // مفتوح
  completed, // مكتمل
  locked,    // مغلق
}

/// درس مع حالته
class LessonWithStatus {
  final LessonModel lesson;
  final LessonStatus status;

  LessonWithStatus({
    required this.lesson,
    required this.status,
  });
}

/// إحصائيات الذاكرة
class MemoryStats {
  final int loadedLessons;
  final int loadedUnits;
  final int loadingUnits;
  final int localLessons;
  final int maxLoadedLessons;
  final int maxLoadedUnits;

  MemoryStats({
    required this.loadedLessons,
    required this.loadedUnits,
    required this.loadingUnits,
    required this.localLessons,
    required this.maxLoadedLessons,
    required this.maxLoadedUnits,
  });

  double get memoryUsagePercentage => 
      maxLoadedLessons > 0 ? (loadedLessons / maxLoadedLessons) * 100 : 0;

  bool get isMemoryFull => loadedLessons >= maxLoadedLessons;
  bool get isUnitsLimitReached => loadedUnits >= maxLoadedUnits;
}
