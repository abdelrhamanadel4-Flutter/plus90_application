import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Auth/choosetype.dart' as AppRoutes;
import 'package:plus90_application/Auth/choosetype.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Registers extends StatefulWidget {
  @override
  State<Registers> createState() => _RegistersState();
}

class _RegistersState extends State<Registers> {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  TextEditingController name = TextEditingController(text: 'John Doe');

  TextEditingController email = TextEditingController(text: 'medo@example.com');

  TextEditingController phone = TextEditingController(text: '+1234567890');

  TextEditingController password = TextEditingController(text: 'password123');

  TextEditingController confirmPassword = TextEditingController(
    text: 'password123',
  );

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.07),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: height(context) * 0.08),

                Row(
                  children: [
                    SizedBox(width: width(context) * 0.01),
                    GestureDetector(
                      child: Image.asset(AppAssets.back),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: width(context) * 0.1),
                    Text('Register', style: AppStyle.bold32black),
                    SizedBox(width: width(context) * 0.18),
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
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: name,
                  hint: 'Enter your  Full Name',
                  keyboardType: TextInputType.text,
                  hintStyle: AppStyle.medium11ramdi,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Email', style: AppStyle.medium14orange),
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: email,
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  hintStyle: AppStyle.medium11ramdi,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter your email';
                    }
                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(text);
                    if (!emailValid) return 'Please enter valid email';
                    return null;
                  },
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Phone', style: AppStyle.medium14orange),
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: phone,
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  hintStyle: AppStyle.medium11ramdi,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    final bool phoneValid = RegExp(
                      r'^\+?[0-9]{7,15}$',
                    ).hasMatch(text);
                    if (!phoneValid) return 'Please enter valid phone number';
                    return null;
                  },
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Password', style: AppStyle.medium14orange),
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: password,
                  hint: 'At least 8 characters',
                  keyboardType: TextInputType.text,
                  hintStyle: AppStyle.medium11ramdi,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (text.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height(context) * 0.03),

                Text('Confirm Password', style: AppStyle.medium14orange),
                SizedBox(height: height(context) * 0.01),
                CustomTextFormField(
                  controller: confirmPassword,
                  hint: 'Re-type password',
                  keyboardType: TextInputType.text,
                  hintStyle: AppStyle.medium11ramdi,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (text != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height(context) * 0.05),
                CustomElevatedButton(
                  onPressed: () {
                    register();
                    //
                    // Handle registration logic here
                  },
                  text: 'Register',
                  textStyle: AppStyle.semibold20white,
                ),
                SizedBox(height: height(context) * 0.04),
                GestureDetector(
                  child: Text(
                    'Already have an account? Login',
                    textAlign: TextAlign.center,
                    style: AppStyle.medium16black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
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
    if (formKey.currentState?.validate() == true) {
      //registration logic here
      //show loading
      DialogUtils.showLoading(context: context, loadingText: 'Registering...');
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );

        //hide loading
        DialogUtils.hideLoading(context: context);
        //show message
        DialogUtils.showMessage(
          context: context,
          message: 'Registration successful. Please login.',
          title: 'Success',
          posActionName: 'OK',
          posAction: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Choosetype(
                  name: name.text,
                  email: email.text,
                  phone: phone.text,
                ),
              ),
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //hide loading
          DialogUtils.hideLoading(context: context);
          //show message
          DialogUtils.showMessage(
            context: context,
            message: 'The password provided is too weak.',
            title: 'Error',
            posActionName: 'OK',
          );

          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context: context);

          //hide loading

          //show message
          DialogUtils.showMessage(
            context: context,
            message: 'The account already exists for that email.',
            title: 'Error',
            posActionName: 'OK',
          );
          print('The account already exists for that email.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context: context);
        //show message
        DialogUtils.showMessage(
          context: context,
          message: e.toString(),
          title: 'Error',
          posActionName: 'OK',
        );
        print(e);
      }

      // Navigator.pushNamedAndRemoveUntil(context,Approutes.login, (route) => false, );
    }
  }
}
