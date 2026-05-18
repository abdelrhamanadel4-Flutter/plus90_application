import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();

  bool _initialized = false;

  GoogleSignInService._internal();

  factory GoogleSignInService() {
    return _instance;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '665416076642-96guqb2rtt8ho4kulga2vcev5ggmsk2f.apps.googleusercontent.com',
      );
      _initialized = true;
    }
  }

  // ✅ طريقة جديدة — بترجع الـ user مباشرة بدون stream
  Future<GoogleSignInAccount?> signIn() async {
    await _ensureInitialized();

    try {
      // ✅ استنى النتيجة من attemptLightweightAuthentication
      final silentUser = await GoogleSignIn.instance
          .attemptLightweightAuthentication();
      if (silentUser != null) {
        print('✅ Silent sign in: ${silentUser.email}');
        return silentUser;
      }
    } catch (e) {
      print('Silent error: $e');
    }

    // لو silent فشل، افتح الـ account picker
    if (GoogleSignIn.instance.supportsAuthenticate()) {
      try {
        final account = await GoogleSignIn.instance.authenticate();
        print('✅ Authenticate sign in: ${account.email}');
        return account;
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          print('ℹ️ User canceled');
          return null;
        }
        rethrow;
      }
    }

    print('❌ supportsAuthenticate = false');
    return null;
  }

  Future<AuthCredential> getFirebaseCredential(
    GoogleSignInAccount googleUser,
  ) async {
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    print('✅ idToken: ${googleAuth.idToken != null ? "exists" : "null"}');

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return credential;
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
  }

  Future<void> disconnect() async {
    await GoogleSignIn.instance.disconnect();
  }
}
