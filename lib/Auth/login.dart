import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Login extends StatelessWidget {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(context) * 0.07),
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
            Text('Shop smarter. Save more.', style: AppStyle.reqular20orange),
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
    );
  }
}
