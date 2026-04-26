import 'package:flutter/material.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.offwhite,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(context) * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(AppAssets.Auth),
            SizedBox(height: height(context) * 0.07),
            CustomElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Approutes.login);
              },
              text: 'Login ',
              textStyle: AppStyle.semibold20white,
            ),
            SizedBox(height: height(context) * 0.03),
            CustomElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Approutes.registers);
              },
              text: 'Registers',

              backgroundColor: Colors.transparent,
              borderColor: AppColor.orange,
              textStyle: AppStyle.semibold20orange,
            ),
            SizedBox(height: height(context) * 0.14),
            Text(
              'Continue as a guest',
              textAlign: TextAlign.center,
              style: AppStyle.medium16black,
            ),
          ],
        ),
      ),
    );
  }
}
