import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Home/homeScrean.dart' as AppRoutes;
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Login extends StatelessWidget {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;
  TextEditingController email = TextEditingController(text: 'medo@example.com');
  TextEditingController password = TextEditingController(text: 'password123');
  final formKey = GlobalKey<FormState>();

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SizedBox(width: width(context) * 0.01),
                    GestureDetector(
                      child: Image.asset(AppAssets.back),
                      onTap: () {
                        Navigator.pop(context);
                      },
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
                  validator: (text) {
                    if (text == null || text.trim().isEmpty)
                      return 'please enter email';
                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(text);
                    if (!emailValid) {
                      return 'Please enter Vaild Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height(context) * 0.02),
                Text('Password', style: AppStyle.medium14orange),
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: password,
                  hint: 'Enter your password',
                  obscureText: true,
                  hintStyle: AppStyle.medium11ramdi,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty)
                      return 'please enter password';
                    if (text.trim().length < 6)
                      return 'password must be at least 6 characters';
                    return null;
                  },
                ),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {},

                      child: Text(
                        'Forgot Password?',
                        style: AppStyle.medium15orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(context) * 0.05),

                CustomElevatedButton(
                  onPressed: () {
                    login(context);
                    // Handle login logic here
                  },
                  text: 'Login ',
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
                    Image.asset(AppAssets.google),
                    SizedBox(width: width(context) * 0.05),
                    Image.asset(AppAssets.facebook),
                    SizedBox(width: width(context) * 0.05),
                    Image.asset(AppAssets.apple),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      //todo: login logic here
      //Show loading
      DialogUtils.showLoading(context: context, loadingText: 'Logging in...');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );
        DialogUtils.hideLoading(context: context);
        DialogUtils.showMessage(
          context: context,
          message: 'Login Successfully.',
          title: 'Success',
          posActionName: 'OK',
          posAction: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(Approutes.HomeScreen, (route) => false);
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: 'No user found for that email.',
            title: 'Error',
            posActionName: 'OK',
          );
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: 'Wrong password provided for that user.',
            title: 'Error',
            posActionName: 'OK',
          );
          print('Wrong password provided for that user.');
        }
        DialogUtils.hideLoading(context: context);
        DialogUtils.showMessage(
          context: context,
          message: 'Wrong password or email provided for that user.',
          title: 'Error',
          posActionName: 'OK',
        );
      }

      // Navigator.of( context,).pushNamedAndRemoveUntil(Approutes.HomeScreen, (route) => false);
    }
  }
}
