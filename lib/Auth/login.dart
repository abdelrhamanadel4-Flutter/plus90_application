import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Auth/google.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscurePassword = true;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.07),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SizedBox(width: width(context) * 0.01),
                    GestureDetector(
                      child: Image.asset(AppAssets.back),
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(width: width(context) * 0.17),
                    Text('Login', style: AppStyle.bold32black),
                    SizedBox(width: width(context) * 0.18),
                  ],
                ),
                SizedBox(height: height(context) * 0.05),
                Text('Welcome Back', style: AppStyle.semibold24orange),
                Text(
                  'Shop smarter. Save more.',
                  style: AppStyle.reqular20orange,
                ),
                SizedBox(height: height(context) * 0.05),

                Text('Email', style: AppStyle.medium14orange),
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: email,
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  hintStyle: AppStyle.medium11ramdi,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter email';
                    final valid = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(v.trim());
                    return valid ? null : 'Please enter valid email';
                  },
                ),
                SizedBox(height: height(context) * 0.02),

                Text('Password', style: AppStyle.medium14orange),
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: password,
                  hint: 'Enter your password',
                  hintStyle: AppStyle.medium11ramdi,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter password';
                    if (v.trim().length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),

                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: _forgotPassword,
                      child: Text(
                        'Forgot Password?',
                        style: AppStyle.medium15orange,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.05),
                CustomElevatedButton(
                  onPressed: _login,
                  text: 'Login',
                  textStyle: AppStyle.semibold20white,
                ),
                SizedBox(height: height(context) * 0.03),

                Text(
                  'Or continue with',
                  textAlign: TextAlign.center,
                  style: AppStyle.semibold14orange,
                ),
                SizedBox(height: height(context) * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Image.asset(AppAssets.google),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // Google Sign-In
  // =========================================================
  Future<void> _signInWithGoogle() async {
    try {
      DialogUtils.showLoading(context: context, loadingText: 'Signing in...');

      final service = GoogleSignInService();
      final googleUser = await service.signIn();

      if (googleUser == null) {
        if (mounted) DialogUtils.hideLoading(context: context);
        return;
      }

      final credential = await service.getFirebaseCredential(googleUser);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user!;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone': '',
          'role': 'not_selected',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      DialogUtils.hideLoading(context: context);

      final String role = doc.data()?['role'] ?? 'not_selected';

      // ✅ لو role مش متحدد، روح Choosetype مع الـ arguments
      if (role == 'not_selected') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Approutes.Choosetype,
          (route) => false,
          arguments: {
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'phone': '',
          },
        );
        return;
      }

      final double? lat = (doc.data()?['lat'] as num?)?.toDouble();
      final double? lng = (doc.data()?['lng'] as num?)?.toDouble();

      if (lat == null || lng == null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Approutes.ChooseLocationScreen,
          (route) => false,
          arguments: user.uid,
        );
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        role == 'user' ? Approutes.HomeScreen : Approutes.HomescreanStore,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      DialogUtils.hideLoading(context: context);
      DialogUtils.showMessage(
        context: context,
        title: 'Error',
        message: e.toString(),
        posActionName: 'OK',
      );
    }
  }

  // =========================================================
  // Login Logic
  // =========================================================
  Future<void> _login() async {
    if (formKey.currentState?.validate() != true) return;

    DialogUtils.showLoading(context: context, loadingText: 'Logging in...');

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final user = credential.user!;
      await user.reload();
      final freshUser = FirebaseAuth.instance.currentUser!;

      if (!freshUser.emailVerified) {
        await FirebaseAuth.instance.signOut();
        DialogUtils.hideLoading(context: context);
        DialogUtils.showMessage(
          context: context,
          title: 'Email Not Verified',
          message:
              'You need to verify your email before logging in.\nCheck your inbox or tap "Resend".',
          posActionName: 'Resend',
          posAction: () => _resendVerificationEmail(),
          negActionName: 'OK',
        );
        return;
      }

      DialogUtils.hideLoading(context: context);
      await _navigateAfterLogin(freshUser);
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context: context);

      String msg;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          msg = 'Incorrect email or password';
          break;
        case 'user-disabled':
          msg = 'This account has been disabled';
          break;
        case 'too-many-requests':
          msg = 'Too many attempts, please try again later';
          break;
        case 'network-request-failed':
          msg = 'No internet connection, please check your network';
          break;
        default:
          msg = 'Login failed, please try again';
      }

      DialogUtils.showMessage(
        context: context,
        title: 'Login Failed',
        message: msg,
        posActionName: 'OK',
      );
    }
  }

  // =========================================================
  // إعادة إرسال رسالة التأكيد
  // =========================================================
  Future<void> _resendVerificationEmail() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      await credential.user?.sendEmailVerification();
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        DialogUtils.showMessage(
          context: context,
          title: 'Email Sent ✅',
          message:
              'Check your inbox and verify your email, then come back and log in.',
          posActionName: 'OK',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String msg = e.code == 'too-many-requests'
            ? 'Too many requests, please wait a moment and try again'
            : (e.message ?? 'Something went wrong, please try again');
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: msg,
          posActionName: 'OK',
        );
      }
    }
  }

  // =========================================================
  // Navigation بعد Login
  // =========================================================
  Future<void> _navigateAfterLogin(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      final String role = doc.data()?['role'] ?? 'not_selected';

      if (role == 'not_selected') {
        DialogUtils.showMessage(
          context: context,
          message: 'Please choose your account type first',
          title: 'Warning',
          posActionName: 'OK',
          posAction: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Approutes.Choosetype,
              (route) => false,
              arguments: {
                'name': user.displayName ?? '',
                'email': user.email ?? '',
                'phone': '',
              },
            );
          },
        );
        return;
      }

      final double? lat = (doc.data()?['lat'] as num?)?.toDouble();
      final double? lng = (doc.data()?['lng'] as num?)?.toDouble();

      DialogUtils.showMessage(
        context: context,
        message: 'Login Successfully',
        title: 'Success',
        posActionName: 'OK',
        posAction: () {
          if (!mounted) return;

          if (lat == null || lng == null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Approutes.ChooseLocationScreen,
              (route) => false,
              arguments: user.uid,
            );
            return;
          }

          Navigator.pushNamedAndRemoveUntil(
            context,
            role == 'user' ? Approutes.HomeScreen : Approutes.HomescreanStore,
            (route) => false,
          );
        },
      );
    } catch (_) {
      if (mounted) {
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: 'Failed to load user data, please try again',
          posActionName: 'OK',
        );
      }
    }
  }

  // =========================================================
  // Forgot Password
  // =========================================================
  Future<void> _forgotPassword() async {
    if (email.text.trim().isEmpty) {
      DialogUtils.showMessage(
        context: context,
        title: 'Warning',
        message: 'Please enter your email first, then tap "Forgot Password"',
        posActionName: 'OK',
      );
      return;
    }

    DialogUtils.showLoading(context: context, loadingText: 'Sending...');
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.text.trim(),
      );
      DialogUtils.hideLoading(context: context);
      if (mounted) {
        DialogUtils.showMessage(
          context: context,
          title: 'Email Sent ✅',
          message:
              'We sent you a password reset email, please check your inbox.',
          posActionName: 'OK',
        );
      }
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context: context);
      String msg = e.code == 'user-not-found'
          ? 'This email is not registered'
          : (e.message ?? 'Something went wrong, please try again');
      if (mounted) {
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: msg,
          posActionName: 'OK',
        );
      }
    }
  }
}
