import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app_color.dart';

class Apptheme {
  static final ThemeData darktheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.whiteColor,
      selectedItemColor: AppColor.orange,
      unselectedItemColor: AppColor.grayColor2,
      showSelectedLabels: true,
    ),

    fontFamily: 'Poppins',
  );
}
