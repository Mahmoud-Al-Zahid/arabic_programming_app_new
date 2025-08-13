import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isGuestUser = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null || _isGuestUser;
  bool get isGuestUser => _isGuestUser;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
    _loadGuestStatus();
  }

  Future<void> _loadGuestStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isGuestUser = prefs.getBool('is_guest_user') ?? false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      print('🔐 بدء تسجيل الدخول...');
      
      // إضافة timeout لتجنب التأخير الطويل
      final credential = await FirebaseService.signInWithEmailAndPassword(email, password)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception('انتهت مهلة الاتصال - تأكد من اتصال الإنترنت');
      });
      
      if (credential != null) {
        _user = credential.user;
        _isGuestUser = false;
        
        print('✅ تم تسجيل الدخول بنجاح');
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest_user', false);
        await prefs.setBool('stay_logged_in', true);
        
        // Update last login time with timeout
        if (_user != null) {
          try {
            await FirebaseService.updateUserData(_user!.uid, {
              'lastLoginAt': FieldValue.serverTimestamp(),
            }).timeout(const Duration(seconds: 5));
          } catch (e) {
            print('⚠️ فشل في تحديث وقت آخر دخول: $e');
            // لا نفشل العملية بسبب هذا الخطأ
          }
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول: $e');
      _setError(_getArabicErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      print('🔐 بدء تسجيل الدخول عبر Google...');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn()
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw Exception('انتهت مهلة تسجيل الدخول عبر Google');
      });
      
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential)
          .timeout(const Duration(seconds: 15));
      
      _user = userCredential.user;
      _isGuestUser = false;

      if (_user != null) {
        print('✅ تم تسجيل الدخول عبر Google بنجاح');
        
        // إنشاء أو تحديث بيانات المستخدم مع timeout
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .get()
              .timeout(const Duration(seconds: 10));

          if (!userDoc.exists) {
            final userModel = UserModel(
              id: _user!.uid,
              name: _user!.displayName ?? 'مستخدم Google',
              email: _user!.email ?? '',
              createdAt: DateTime.now(),
              lastLoginAt: DateTime.now(),
            );
            await FirebaseService.createUserDocument(userModel)
                .timeout(const Duration(seconds: 10));
          } else {
            await FirebaseService.updateUserData(_user!.uid, {
              'lastLoginAt': FieldValue.serverTimestamp(),
            }).timeout(const Duration(seconds: 5));
          }
        } catch (e) {
          print('⚠️ فشل في تحديث بيانات المستخدم: $e');
          // لا نفشل العملية بسبب هذا الخطأ
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest_user', false);
        await prefs.setBool('stay_logged_in', true);
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول عبر Google: $e');
      _setError(_getArabicErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      _setLoading(true);
      _clearError();

      print('🔐 بدء تسجيل الدخول عبر Facebook...');

      final LoginResult result = await FacebookAuth.instance.login()
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw Exception('انتهت مهلة تسجيل الدخول عبر Facebook');
      });
      
      if (result.status != LoginStatus.success) return false;

      final OAuthCredential facebookAuthCredential = 
          FacebookAuthProvider.credential(result.accessToken!.tokenString);

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential)
          .timeout(const Duration(seconds: 15));
      
      _user = userCredential.user;
      _isGuestUser = false;

      if (_user != null) {
        print('✅ تم تسجيل الدخول عبر Facebook بنجاح');
        
        // إنشاء أو تحديث بيانات المستخدم مع timeout
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .get()
              .timeout(const Duration(seconds: 10));

          if (!userDoc.exists) {
            final userModel = UserModel(
              id: _user!.uid,
              name: _user!.displayName ?? 'مستخدم Facebook',
              email: _user!.email ?? '',
              createdAt: DateTime.now(),
              lastLoginAt: DateTime.now(),
            );
            
            await FirebaseService.createUserDocument(userModel)
                .timeout(const Duration(seconds: 10));
          } else {
            await FirebaseService.updateUserData(_user!.uid, {
              'lastLoginAt': FieldValue.serverTimestamp(),
            }).timeout(const Duration(seconds: 5));
          }
        } catch (e) {
          print('⚠️ فشل في تحديث بيانات المستخدم: $e');
          // لا نفشل العملية بسبب هذا الخطأ
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest_user', false);
        await prefs.setBool('stay_logged_in', true);
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول عبر Facebook: $e');
      _setError(_getArabicErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInAsGuest() async {
    try {
      _setLoading(true);
      _clearError();

      print('👤 تسجيل الدخول كضيف...');

      _isGuestUser = true;
      _user = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest_user', true);
      await prefs.setBool('stay_logged_in', true);

      print('✅ تم تسجيل الدخول كضيف بنجاح');
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول كضيف: $e');
      _setError(_getArabicErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      print('📝 بدء إنشاء حساب جديد...');
      
      final credential = await FirebaseService.createUserWithEmailAndPassword(email, password)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception('انتهت مهلة إنشاء الحساب - تأكد من اتصال الإنترنت');
      });
      
      if (credential != null) {
        _user = credential.user;
        _isGuestUser = false;
        
        print('✅ تم إنشاء الحساب بنجاح');
        
        // Create user document in Firestore with timeout
        final userModel = UserModel(
          id: _user!.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        
        await FirebaseService.createUserDocument(userModel)
            .timeout(const Duration(seconds: 10));

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest_user', false);
        await prefs.setBool('stay_logged_in', true);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('❌ خطأ في إنشاء الحساب: $e');
      _setError(_getArabicErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      await FirebaseService.sendPasswordResetEmail(email)
          .timeout(const Duration(seconds: 10));
      return true;
    } catch (e) {
      _setError(_getArabicErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      if (!_isGuestUser) {
        await FirebaseService.signOut();
        await GoogleSignIn().signOut();
      }
      
      _user = null;
      _isGuestUser = false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest_user', false);
      await prefs.setBool('stay_logged_in', false);
      
      notifyListeners();
    } catch (e) {
      _setError(_getArabicErrorMessage(e.toString()));
    }
  }

  Future<bool> checkSavedLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final stayLoggedIn = prefs.getBool('stay_logged_in') ?? false;
    final isGuest = prefs.getBool('is_guest_user') ?? false;
    
    if (stayLoggedIn) {
      if (isGuest) {
        _isGuestUser = true;
        notifyListeners();
        return true;
      } else if (_user != null) {
        return true;
      }
    }
    return false;
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

  String _getArabicErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني';
    } else if (error.contains('wrong-password')) {
      return 'كلمة المرور غير صحيحة';
    } else if (error.contains('email-already-in-use')) {
      return 'هذا البريد الإلكتروني مستخدم بالفعل';
    } else if (error.contains('weak-password')) {
      return 'كلمة المرور ضعيفة جداً';
    } else if (error.contains('invalid-email')) {
      return 'البريد الإلكتروني غير صحيح';
    } else if (error.contains('network-request-failed') || error.contains('انتهت مهلة')) {
      return 'خطأ في الاتصال بالإنترنت - تحقق من اتصالك وحاول مرة أخرى';
    } else if (error.contains('too-many-requests')) {
      return 'تم تجاوز عدد المحاولات المسموح - حاول مرة أخرى لاحقاً';
    } else if (error.contains('operation-not-allowed')) {
      return 'هذه الطريقة غير مفعلة حالياً';
    }
    return 'حدث خطأ غير متوقع - حاول مرة أخرى';
  }
}
