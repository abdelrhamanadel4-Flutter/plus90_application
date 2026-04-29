import 'package:flutter/material.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Registers extends StatelessWidget {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
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
                  Navigator.pushNamed(context, Approutes.Choosetype);
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
    );
  }
}
