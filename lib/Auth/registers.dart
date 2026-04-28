import 'package:flutter/material.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Registers extends StatelessWidget {
  const Registers({super.key});

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;
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
                hint: 'Enter your  Full Name',
                keyboardType: TextInputType.text,
                hintStyle: AppStyle.medium11ramdi,
              ),
              SizedBox(height: height(context) * 0.03),

              Text('Email', style: AppStyle.medium14orange),
              SizedBox(height: height(context) * 0.01),
              CustomTextFormField(
                hint: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                hintStyle: AppStyle.medium11ramdi,
              ),
              SizedBox(height: height(context) * 0.03),

              Text('Phone', style: AppStyle.medium14orange),
              SizedBox(height: height(context) * 0.01),
              CustomTextFormField(
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                hintStyle: AppStyle.medium11ramdi,
              ),
              SizedBox(height: height(context) * 0.03),

              Text('Password', style: AppStyle.medium14orange),
              SizedBox(height: height(context) * 0.01),
              CustomTextFormField(
                hint: 'At least 8 characters',
                keyboardType: TextInputType.text,
                hintStyle: AppStyle.medium11ramdi,
              ),
              SizedBox(height: height(context) * 0.03),

              Text('Confirm Password', style: AppStyle.medium14orange),
              SizedBox(height: height(context) * 0.01),
              CustomTextFormField(
                hint: 'Re-type password',
                keyboardType: TextInputType.text,
                hintStyle: AppStyle.medium11ramdi,
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
