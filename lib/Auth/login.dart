import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Login({super.key});

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
                    if (text == null || text.trim().isEmpty) {
                      return 'please enter email';
                    }
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
                    if (text == null || text.trim().isEmpty) {
                      return 'please enter password';
                    }
                    if (text.trim().length < 6) {
                      return 'password must be at least 6 characters';
                    }
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
                    GestureDetector(
                      onTap: () {
                        // Handle Google login logic here
                      },
                      child: Image.asset(AppAssets.google),
                    ),
                    SizedBox(width: width(context) * 0.05),
                    Image.asset(AppAssets.facebook),
                    SizedBox(width: width(context) * 0.05),
                    GestureDetector(
                      onTap: () {
                        // Handle Apple login logic here
                      },
                      child: Image.asset(AppAssets.apple),
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

  void login(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;

    DialogUtils.showLoading(context: context, loadingText: 'Logging in...');

    try {
      /// 🔐 Firebase Login
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      final uid = credential.user!.uid;

      /// 📦 Get user data
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      DialogUtils.hideLoading(context: context);

      DialogUtils.showMessage(
        context: context,
        message: 'Login Successfully',
        title: 'Success',
        posActionName: 'OK',

        posAction: () {
          /// 👤 account type
          String accountType = doc.data()?['accountType'] ?? "user";

          /// 📍 location
          double? lat = (doc.data()?['lat'] as num?)?.toDouble();

          double? lng = (doc.data()?['lng'] as num?)?.toDouble();

          /// 🚨 IF NO LOCATION
          if (lat == null || lng == null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Approutes.ChooseLocationScreen,
              (route) => false,
              arguments: uid,
            );

            return;
          }

          /// 👤 USER HOME
          if (accountType == "user") {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Approutes.HomeScreen,
              (route) => false,
            );
          }
          /// 🏪 STORE HOME
          else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Approutes.HomescreanStore,
              (route) => false,
            );
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context: context);

      DialogUtils.showMessage(
        context: context,
        message: e.message ?? "Login Failed",
        title: 'Error',
        posActionName: 'OK',
      );
    }
  }
}
