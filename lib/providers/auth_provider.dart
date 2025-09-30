import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;
  String? _verificationId;

  User? get user => _user;
  bool get isAuthenticated => _user != null && !_user!.isAnonymous;
  bool get isAnonymous => _user?.isAnonymous ?? false;
  bool get isLoading => _isLoading;
  String? get verificationId => _verificationId;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  AuthProvider() {
    _checkAuthStatus();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('onboarding_complete') ?? false;

    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _user = await _mapFirebaseUser(firebaseUser);
      await _loadUserData();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _isLoading = false;
      await logout();
    } else {
      _user = await _mapFirebaseUser(firebaseUser);
      await _loadUserData();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await credential.user!.reload();
        final firebaseUser = _auth.currentUser;
        _user = await _mapFirebaseUser(firebaseUser!);
        await _saveUserData();
      }
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final firebase_auth.OAuthProvider oAuthProvider = firebase_auth.OAuthProvider("apple.com");
      final firebase_auth.AuthCredential authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        rawNonce: credential.nonce,
      );

      await _auth.signInWithCredential(authCredential);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
  
  Future<bool> sendSignInLink(String email) async {
    final acs = firebase_auth.ActionCodeSettings(
      url: 'https://eyeconnect-65sog.page.link/finishSignUp?email=$email',
      handleCodeInApp: true,
      iOSBundleId: 'com.jmr.visionary.visionary',
      androidPackageName: 'com.jmr.visionary.visionary',
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    try {
      await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emailForSignIn', email);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> signInWithEmailLink(String email, String link) async {
    try {
      final userCredential = await _auth.signInWithEmailLink(email: email, emailLink: link);
      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('emailForSignIn');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    {
      required Function(String, int?) codeSent,
      required Function(firebase_auth.FirebaseAuthException) verificationFailed
    }
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: verificationFailed,
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> signInWithSmsCode(String smsCode) async {
    if (_verificationId == null) return false;
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    _hasCompletedOnboarding = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }

  Future<void> completeOnboarding(String updatedName) async {
    if (_user != null) {
      await _auth.currentUser?.updateDisplayName(updatedName);
      _user = _user!.copyWith(name: updatedName);
      _hasCompletedOnboarding = true;
      
      await _saveUserData();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? avatar}) async {
    if (_user != null) {
       if (name != null) {
        await _auth.currentUser?.updateDisplayName(name);
      }
      if (avatar != null) {
        await _auth.currentUser?.updatePhotoURL(avatar);
      }
      
      await _auth.currentUser?.reload();
      final firebaseUser = _auth.currentUser;
      _user = await _mapFirebaseUser(firebaseUser!);
      
      await _saveUserData();
      notifyListeners();
    }
  }

  Future<User> _mapFirebaseUser(firebase_auth.User firebaseUser) async {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? _extractNameFromEmail(firebaseUser.email ?? ''),
      email: firebaseUser.email ?? '',
      avatar: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      isAnonymous: firebaseUser.isAnonymous,
    );
  }

  Future<void> _saveUserData() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', _user!.toJson());
    }
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
       if (userJson != null) {
         final storedUser = User.fromJson(userJson);
         _user = _user!.copyWith(name: storedUser.name, avatar: storedUser.avatar);
       }
    }
  }

  String _extractNameFromEmail(String email) {
    if (email.isEmpty) return 'Guest User';
    final username = email.split('@')[0];
    return username.replaceAll(RegExp(r'[^a-zA-Z]'), ' ').trim();
  }
}
