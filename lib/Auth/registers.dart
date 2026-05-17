import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Auth/google.dart';
import 'package:plus90_application/screens/EmailVerificationScreen.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Registers extends StatefulWidget {
  const Registers({super.key});

  @override
  State<Registers> createState() => _RegistersState();
}

class _RegistersState extends State<Registers> {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: height(context) * 0.08),
                Row(
                  children: [
                    GestureDetector(
                      child: Image.asset(AppAssets.back),
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(width: width(context) * 0.1),
                    Text('Register', style: AppStyle.bold32black),
                  ],
                ),
                SizedBox(height: height(context) * 0.01),
                Text(
                  'Fresh deals, tiny prices',
                  style: AppStyle.semibold24orange,
                ),
                Text(
                  'Get products before they expire',
                  style: AppStyle.reqular20orange,
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Name', style: AppStyle.medium14orange),
                const SizedBox(height: 6),
                CustomTextFormField(
                  controller: name,
                  hint: 'Enter your Full Name',
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Email', style: AppStyle.medium14orange),
                const SizedBox(height: 6),
                CustomTextFormField(
                  controller: email,
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your email';
                    final valid = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(v.trim());
                    return valid ? null : 'Please enter valid email';
                  },
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Phone', style: AppStyle.medium14orange),
                const SizedBox(height: 6),
                CustomTextFormField(
                  controller: phone,
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your phone number';
                    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v.trim())
                        ? null
                        : 'Please enter valid phone number';
                  },
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Password', style: AppStyle.medium14orange),
                const SizedBox(height: 6),
                CustomTextFormField(
                  controller: password,
                  hint: 'At least 8 characters',
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
                    if (v == null || v.isEmpty)
                      return 'Please enter your password';
                    if (v.length < 8)
                      return 'Password must be at least 8 characters';
                    return null;
                  },
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Confirm Password', style: AppStyle.medium14orange),
                const SizedBox(height: 6),
                CustomTextFormField(
                  controller: confirmPassword,
                  hint: 'Re-type password',
                  obscureText: _obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) =>
                      v != password.text ? 'Passwords do not match' : null,
                ),
                SizedBox(height: height(context) * 0.05),

                CustomElevatedButton(
                  onPressed: _register,
                  text: 'Register',
                  textStyle: AppStyle.semibold20white,
                ),
                SizedBox(height: height(context) * 0.03),

                Text(
                  'Or register with',
                  textAlign: TextAlign.center,
                  style: AppStyle.semibold14orange,
                ),
                SizedBox(height: height(context) * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Image.asset(AppAssets.google),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.04),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Already have an account? Login',
                    textAlign: TextAlign.center,
                    style: AppStyle.medium16black,
                  ),
                ),
                SizedBox(height: height(context) * 0.1),
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

      // ✅ روح Choosetype مع الـ arguments
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
  // Register بـ Email & Password
  // =========================================================
  Future<void> _register() async {
    if (formKey.currentState?.validate() != true) return;

    DialogUtils.showLoading(context: context, loadingText: 'Registering...');

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      final user = credential.user;
      if (user == null) throw Exception('User is null');

      await Future.delayed(const Duration(seconds: 1));
      await user.sendEmailVerification();

      DialogUtils.hideLoading(context: context);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationScreen(
              userName: name.text.trim(),
              userPhone: phone.text.trim(),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context: context);

      String msg;
      switch (e.code) {
        case 'weak-password':
          msg = 'Password is too weak, try a stronger one';
          break;
        case 'email-already-in-use':
          msg = 'This email is already registered, try logging in';
          break;
        case 'invalid-email':
          msg = 'Please enter a valid email address';
          break;
        case 'network-request-failed':
          msg = 'No internet connection, please check your network';
          break;
        default:
          msg = 'Registration failed, please try again';
      }

      DialogUtils.showMessage(
        context: context,
        title: 'Registration Failed',
        message: msg,
        posActionName: 'OK',
      );
    } catch (_) {
      DialogUtils.hideLoading(context: context);
      DialogUtils.showMessage(
        context: context,
        title: 'Error',
        message: 'Something went wrong, please try again',
        posActionName: 'OK',
      );
    }
  }
}
