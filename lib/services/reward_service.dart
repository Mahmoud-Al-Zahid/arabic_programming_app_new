import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/lesson_model.dart';

/// خدمة إدارة المكافآت - المصدر الوحيد لحساب وتوزيع XP والجواهر
class RewardService {
  static const String _completedQuizzesKey = 'completed_quizzes_secure';
  // static const String _shareRewardKey = 'share_reward_claimed';
  // static const String _lastShareKey = 'last_share_timestamp';
  static const String _retakeAttemptsKey = 'retake_attempts';
  static const String _lastPassTimestampKey = 'last_pass_timestamp';
  
  /// الحصول على مكافآت الدرس مع نظام تقليل المكافآت للمحاولات المتكررة
  static Future<RewardInfo> getLessonRewardsWithRetakeLogic(
    LessonModel lesson, 
    int quizScore, 
    String userId,
    {bool isRetakeAfterPass = false}
  ) async {
    // استخدام القيم من JSON كما هي
    int baseXP = lesson.xpReward;
    int baseGems = lesson.gemsReward;
    
    // مكافأة إضافية بناءً على الأداء (من JSON أيضاً)
    double performanceMultiplier = 1.0;
    if (quizScore >= 95) {
      performanceMultiplier = 1.5; // 50% إضافية للأداء الممتاز
    } else if (quizScore >= 85) {
      performanceMultiplier = 1.25; // 25% إضافية للأداء الجيد
    } else if (quizScore >= 70) {
      performanceMultiplier = 1.0; // المكافأة الأساسية للنجاح
    } else {
      performanceMultiplier = 0.0; // لا مكافأة للرسوب
    }

    double retakeMultiplier = 1.0;
    if (isRetakeAfterPass && quizScore >= 70) {
      retakeMultiplier = await _calculateRetakeMultiplier(lesson.id, userId);
      print('🔄 محاولة إعادة بعد النجاح - مضاعف التقليل: ${(retakeMultiplier * 100).round()}%');
    }
    
    final finalXP = (baseXP * performanceMultiplier * retakeMultiplier).round();
    final finalGems = (baseGems * performanceMultiplier * retakeMultiplier).round();
    
    return RewardInfo(
      xp: finalXP,
      gems: finalGems,
      source: isRetakeAfterPass ? 'lesson_retake' : 'lesson_completion',
      lessonId: lesson.id,
      score: quizScore,
      retakeMultiplier: retakeMultiplier,
      isRetake: isRetakeAfterPass,
    );
  }

  /// الحصول على مكافآت الدرس من JSON فقط (للتوافق مع الكود القديم)
  static RewardInfo getLessonRewards(LessonModel lesson, int quizScore) {
    // استخدام القيم من JSON كما هي
    int baseXP = lesson.xpReward;
    int baseGems = lesson.gemsReward;
    
    // مكافأة إضافية بناءً على الأداء (من JSON أيضاً)
    double multiplier = 1.0;
    if (quizScore >= 95) {
      multiplier = 1.5; // 50% إضافية للأداء الممتاز
    } else if (quizScore >= 85) {
      multiplier = 1.25; // 25% إضافية للأداء الجيد
    } else if (quizScore >= 70) {
      multiplier = 1.0; // المكافأة الأساسية للنجاح
    } else {
      multiplier = 0.0; // لا مكافأة للرسوب
    }
    
    return RewardInfo(
      xp: (baseXP * multiplier).round(),
      gems: (baseGems * multiplier).round(),
      source: 'lesson_completion',
      lessonId: lesson.id,
      score: quizScore,
    );
  }

  /// حساب مضاعف تقليل المكافآت للمحاولات المتكررة
  static Future<double> _calculateRetakeMultiplier(String lessonId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final retakeKey = '${_retakeAttemptsKey}_${userId}_$lessonId';
      final lastPassKey = '${_lastPassTimestampKey}_${userId}_$lessonId';
      
      // الحصول على آخر وقت نجاح
      final lastPassStr = prefs.getString(lastPassKey);
      if (lastPassStr == null) {
        // لا يوجد نجاح سابق، هذه المحاولة الأولى
        return 1.0;
      }
      
      final lastPassTime = DateTime.parse(lastPassStr);
      final now = DateTime.now();
      final hoursSinceLastPass = now.difference(lastPassTime).inHours;
      
      // إعادة تعيين العداد إذا مر أكثر من 24 ساعة
      if (hoursSinceLastPass >= 24) {
        await prefs.remove(retakeKey);
        print('🔄 تم إعادة تعيين عداد المحاولات بعد 24 ساعة');
        return 0.3; // البداية من 30% بعد إعادة التعيين
      }
      
      // الحصول على عدد المحاولات الحالي
      final currentAttempts = prefs.getInt(retakeKey) ?? 0;
      
      // حساب المضاعف بناءً على عدد المحاولات
      switch (currentAttempts) {
        case 0:
          return 0.3; // 30% للمحاولة الأولى بعد النجاح
        case 1:
          return 0.2; // 20% للمحاولة الثانية
        case 2:
          return 0.1; // 10% للمحاولة الثالثة
        default:
          return 0.0; // 0% للمحاولة الرابعة فما فوق
      }
    } catch (e) {
      print('❌ خطأ في حساب مضاعف إعادة المحاولة: $e');
      return 1.0; // إرجاع المضاعف الكامل في حالة الخطأ
    }
  }

  /// تسجيل محاولة إعادة بعد النجاح
  static Future<void> recordRetakeAttempt(String lessonId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final retakeKey = '${_retakeAttemptsKey}_${userId}_$lessonId';
      
      final currentAttempts = prefs.getInt(retakeKey) ?? 0;
      await prefs.setInt(retakeKey, currentAttempts + 1);
      
      print('📊 تم تسجيل محاولة إعادة رقم ${currentAttempts + 1} للدرس $lessonId');
    } catch (e) {
      print('❌ خطأ في تسجيل محاولة الإعادة: $e');
    }
  }

  /// تسجيل وقت النجاح الأول
  static Future<void> recordFirstPassTime(String lessonId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastPassKey = '${_lastPassTimestampKey}_${userId}_$lessonId';
      
      // تسجيل الوقت فقط إذا لم يكن موجوداً من قبل (النجاح الأول)
      if (!prefs.containsKey(lastPassKey)) {
        await prefs.setString(lastPassKey, DateTime.now().toIso8601String());
        print('✅ تم تسجيل وقت النجاح الأول للدرس $lessonId');
      }
    } catch (e) {
      print('❌ خطأ في تسجيل وقت النجاح: $e');
    }
  }

  /// التحقق من كون هذه محاولة إعادة بعد النجاح
  static Future<bool> isRetakeAfterPass(String lessonId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastPassKey = '${_lastPassTimestampKey}_${userId}_$lessonId';
      
      return prefs.containsKey(lastPassKey);
    } catch (e) {
      print('❌ خطأ في التحقق من حالة الإعادة: $e');
      return false;
    }
  }

  /// الحصول على إحصائيات إعادة المحاولة
  static Future<RetakeStats> getRetakeStats(String lessonId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final retakeKey = '${_retakeAttemptsKey}_${userId}_$lessonId';
      final lastPassKey = '${_lastPassTimestampKey}_${userId}_$lessonId';
      
      final retakeAttempts = prefs.getInt(retakeKey) ?? 0;
      final lastPassStr = prefs.getString(lastPassKey);
      
      DateTime? lastPassTime;
      int? hoursUntilReset;
      
      if (lastPassStr != null) {
        lastPassTime = DateTime.parse(lastPassStr);
        final hoursSinceLastPass = DateTime.now().difference(lastPassTime).inHours;
        hoursUntilReset = hoursSinceLastPass >= 24 ? 0 : (24 - hoursSinceLastPass);
      }
      
      // حساب المضاعف التالي
      double nextMultiplier = 1.0;
      if (lastPassTime != null) {
        if (hoursUntilReset == 0) {
          nextMultiplier = 0.3; // إعادة تعيين
        } else {
          switch (retakeAttempts) {
            case 0:
              nextMultiplier = 0.3;
              break;
            case 1:
              nextMultiplier = 0.2;
              break;
            case 2:
              nextMultiplier = 0.1;
              break;
            default:
              nextMultiplier = 0.0;
          }
        }
      }
      
      return RetakeStats(
        retakeAttempts: retakeAttempts,
        lastPassTime: lastPassTime,
        hoursUntilReset: hoursUntilReset,
        nextRewardMultiplier: nextMultiplier,
        hasPassedBefore: lastPassTime != null,
      );
    } catch (e) {
      print('❌ خطأ في الحصول على إحصائيات الإعادة: $e');
      return RetakeStats(
        retakeAttempts: 0,
        lastPassTime: null,
        hoursUntilReset: null,
        nextRewardMultiplier: 1.0,
        hasPassedBefore: false,
      );
    }
  }
  
  /// التحقق من إكمال الاختبار مسبقاً
  static Future<bool> isQuizCompleted(String lessonId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedQuizzes = await _getSecureCompletedQuizzes();
      
      // إنشاء مفتاح فريد للمستخدم والدرس
      final quizKey = _generateQuizKey(userId, lessonId);
      return completedQuizzes.contains(quizKey);
    } catch (e) {
      print('خطأ في التحقق من إكمال الاختبار: $e');
      return false;
    }
  }
  
  /// تسجيل إكمال الاختبار بشكل آمن
  static Future<void> markQuizCompleted(String lessonId, String userId, int score) async {
    try {
      final quizKey = _generateQuizKey(userId, lessonId);
      final completedQuizzes = await _getSecureCompletedQuizzes();
      
      if (!completedQuizzes.contains(quizKey)) {
        completedQuizzes.add(quizKey);
        await _saveSecureCompletedQuizzes(completedQuizzes);
        
        // حفظ تفاصيل إضافية للتحقق
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('quiz_${quizKey}_score', score.toString());
        await prefs.setString('quiz_${quizKey}_timestamp', DateTime.now().toIso8601String());
      }
    } catch (e) {
      print('خطأ في تسجيل إكمال الاختبار: $e');
    }
  }
  
  /*
  /// التحقق من إمكانية الحصول على مكافأة المشاركة
  static Future<bool> canClaimShareReward(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final claimed = prefs.getBool('${_shareRewardKey}_$userId') ?? false;
      
      if (claimed) {
        // التحقق من آخر مشاركة (يمكن المشاركة مرة واحدة كل 24 ساعة)
        final lastShareStr = prefs.getString('${_lastShareKey}_$userId');
        if (lastShareStr != null) {
          final lastShare = DateTime.parse(lastShareStr);
          final now = DateTime.now();
          final difference = now.difference(lastShare).inHours;
          
          return difference >= 24; // يمكن المشاركة مرة كل 24 ساعة
        }
      }
      
      return !claimed;
    } catch (e) {
      print('خطأ في التحقق من مكافأة المشاركة: $e');
      return false;
    }
  }
  
  /// تسجيل مكافأة المشاركة
  static Future<RewardInfo?> claimShareReward(String userId, bool actuallyShared) async {
    try {
      // التحقق من المشاركة الفعلية
      if (!actuallyShared) {
        return null;
      }
      
      final canClaim = await canClaimShareReward(userId);
      if (!canClaim) {
        return null;
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${_shareRewardKey}_$userId', true);
      await prefs.setString('${_lastShareKey}_$userId', DateTime.now().toIso8601String());
      
      return RewardInfo(
        xp: 0,
        gems: 50,
        source: 'app_share',
        lessonId: null,
        score: null,
      );
    } catch (e) {
      print('خطأ في تسجيل مكافأة المشاركة: $e');
      return null;
    }
  }
  */
  
  /// إنشاء مفتاح آمن للاختبار
  static String _generateQuizKey(String userId, String lessonId) {
    final input = '$userId:$lessonId:${DateTime.now().toIso8601String().substring(0, 10)}';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16); // استخدام أول 16 حرف فقط
  }
  
  /// الحصول على قائمة الاختبارات المكتملة بشكل آمن
  static Future<List<String>> _getSecureCompletedQuizzes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptedData = prefs.getString(_completedQuizzesKey);
      
      if (encryptedData == null) {
        return [];
      }
      
      // فك التشفير البسيط (يمكن تحسينه لاحقاً)
      final decodedData = utf8.decode(base64.decode(encryptedData));
      final List<dynamic> jsonList = json.decode(decodedData);
      
      return jsonList.cast<String>();
    } catch (e) {
      print('خطأ في قراءة الاختبارات المكتملة: $e');
      return [];
    }
  }
  
  /// حفظ قائمة الاختبارات المكتملة بشكل آمن
  static Future<void> _saveSecureCompletedQuizzes(List<String> completedQuizzes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // تشفير بسيط (يمكن تحسينه لاحقاً)
      final jsonData = json.encode(completedQuizzes);
      final encodedData = base64.encode(utf8.encode(jsonData));
      
      await prefs.setString(_completedQuizzesKey, encodedData);
    } catch (e) {
      print('خطأ في حفظ الاختبارات المكتملة: $e');
    }
  }
  
  /// التحقق من صحة النتيجة
  static bool isValidScore(int score, int totalQuestions) {
    return score >= 0 && score <= 100 && totalQuestions > 0;
  }
  
  /// حساب النتيجة بناءً على الإجابات الصحيحة
  static int calculateScore(int correctAnswers, int totalQuestions) {
    if (totalQuestions <= 0) return 0;
    return ((correctAnswers / totalQuestions) * 100).round();
  }
  
  /// إعادة تعيين جميع المكافآت (للاختبار فقط)
  static Future<void> resetAllRewards(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // إزالة جميع البيانات المتعلقة بالمكافآت
      await prefs.remove(_completedQuizzesKey);
      // await prefs.remove('${_shareRewardKey}_$userId');
      // await prefs.remove('${_lastShareKey}_$userId');
      
      final keys = prefs.getKeys();
      for (String key in keys) {
        if (key.startsWith('quiz_') && (key.contains('_score') || key.contains('_timestamp'))) {
          await prefs.remove(key);
        }
        if (key.contains(_retakeAttemptsKey) || key.contains(_lastPassTimestampKey)) {
          await prefs.remove(key);
        }
        if (key.contains('share_reward') || key.contains('last_share')) {
          await prefs.remove(key);
        }
      }
      
      print('تم إعادة تعيين جميع المكافآت للمستخدم: $userId');
    } catch (e) {
      print('خطأ في إعادة تعيين المكافآت: $e');
    }
  }
}

/// معلومات المكافأة
class RewardInfo {
  final int xp;
  final int gems;
  final String source;
  final String? lessonId;
  final int? score;
  final double? retakeMultiplier;
  final bool? isRetake;
  
  RewardInfo({
    required this.xp,
    required this.gems,
    required this.source,
    this.lessonId,
    this.score,
    this.retakeMultiplier,
    this.isRetake,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'xp': xp,
      'gems': gems,
      'source': source,
      'lessonId': lessonId,
      'score': score,
      'retakeMultiplier': retakeMultiplier,
      'isRetake': isRetake,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  @override
  String toString() {
    return 'RewardInfo(xp: $xp, gems: $gems, source: $source, lessonId: $lessonId, score: $score, retakeMultiplier: $retakeMultiplier, isRetake: $isRetake)';
  }
}

/// إحصائيات إعادة المحاولة
class RetakeStats {
  final int retakeAttempts;
  final DateTime? lastPassTime;
  final int? hoursUntilReset;
  final double nextRewardMultiplier;
  final bool hasPassedBefore;

  RetakeStats({
    required this.retakeAttempts,
    required this.lastPassTime,
    required this.hoursUntilReset,
    required this.nextRewardMultiplier,
    required this.hasPassedBefore,
  });

  String get nextRewardPercentage => '${(nextRewardMultiplier * 100).round()}%';
  
  bool get canGetFullReward => nextRewardMultiplier >= 1.0;
  bool get willGetReducedReward => nextRewardMultiplier > 0.0 && nextRewardMultiplier < 1.0;
  bool get willGetNoReward => nextRewardMultiplier == 0.0;
  
  String get statusMessage {
    if (!hasPassedBefore) {
      return 'المحاولة الأولى - مكافأة كاملة';
    } else if (hoursUntilReset != null && hoursUntilReset! > 0) {
      if (willGetNoReward) {
        return 'لا توجد مكافأة - انتظر ${hoursUntilReset}h لإعادة التعيين';
      } else {
        return 'مكافأة مقللة ${nextRewardPercentage} - إعادة تعيين خلال ${hoursUntilReset}h';
      }
    } else {
      return 'تم إعادة التعيين - مكافأة ${nextRewardPercentage}';
    }
  }
}
