import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Auth/choosetype.dart';
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

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
                Text('Fresh deals, tiny prices',
                    style: AppStyle.semibold24orange),
                Text('Get products before they expire',
                    style: AppStyle.reqular20orange),

                SizedBox(height: height(context) * 0.03),

                Text('Name', style: AppStyle.medium14orange),
                CustomTextFormField(
                  controller: name,
                  hint: 'Enter your Full Name',
                  validator: (text) =>
                      text == null || text.isEmpty ? 'Please enter your name' : null,
                ),

                SizedBox(height: height(context) * 0.03),

                Text('Email', style: AppStyle.medium14orange),
                CustomTextFormField(
                  controller: email,
                  hint: 'Enter your email address',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailValid = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(text);
                    return emailValid ? null : 'Please enter valid email';
                  },
                ),

                SizedBox(height: height(context) * 0.03),

                Text('Phone', style: AppStyle.medium14orange),
                CustomTextFormField(
                  controller: phone,
                  hint: 'Enter your phone number',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    final phoneValid =
                        RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text);
                    return phoneValid ? null : 'Please enter valid phone number';
                  },
                ),

                SizedBox(height: height(context) * 0.03),

                Text('Password', style: AppStyle.medium14orange),
                CustomTextFormField(
                  controller: password,
                  hint: 'At least 8 characters',
                  validator: (text) =>
                      text == null || text.length < 8
                          ? 'Password must be at least 8 characters'
                          : null,
                ),

                SizedBox(height: height(context) * 0.03),

                Text('Confirm Password', style: AppStyle.medium14orange),
                CustomTextFormField(
                  controller: confirmPassword,
                  hint: 'Re-type password',
                  validator: (text) =>
                      text != password.text ? 'Passwords do not match' : null,
                ),

                SizedBox(height: height(context) * 0.05),

                CustomElevatedButton(
                  onPressed: register,
                  text: 'Register',
                  textStyle: AppStyle.semibold20white,
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

  void register() async {
    if (formKey.currentState?.validate() != true) return;

    DialogUtils.showLoading(
      context: context,
      loadingText: 'Registering...',
    );

    try {
      /// 🔐 Create Firebase User
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final user = credential.user;

      if (user == null) {
        DialogUtils.hideLoading(context: context);
        DialogUtils.showMessage(
          context: context,
          title: "Error",
          message: "Something went wrong",
        );
        return;
      }

      /// 📦 Save Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        "uid": user.uid,
        "name": name.text.trim(),
        "email": email.text.trim(),
        "phone": phone.text.trim(),
        "role": "not_selected",
        "createdAt": FieldValue.serverTimestamp(),
      });

      DialogUtils.hideLoading(context: context);

      /// 🚀 Go to Choose Type
      DialogUtils.showMessage(
        context: context,
        title: "Success",
        message: "Account created successfully",
        posActionName: "OK",
        posAction: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Choosetype(
                name: name.text.trim(),
                email: email.text.trim(),
                phone: phone.text.trim(),
              ),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context: context);

      String msg = "Something went wrong";

      if (e.code == 'weak-password') {
        msg = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        msg = "Email already exists";
      }

      DialogUtils.showMessage(
        context: context,
        title: "Error",
        message: msg,
        posActionName: "OK",
      );
    } catch (e) {
      DialogUtils.hideLoading(context: context);

      DialogUtils.showMessage(
        context: context,
        title: "Error",
        message: e.toString(),
        posActionName: "OK",
      );
    }
  }
}