import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plus90_application/Auth/auth.dart';
import 'package:plus90_application/Auth/choosetype.dart';
import 'package:plus90_application/Auth/login.dart';
import 'package:plus90_application/Auth/registers.dart';
import 'package:plus90_application/Home/home.dart';
import 'package:plus90_application/Splach/splachScrean.dart';
import 'package:plus90_application/onBorading/onboradingpages.dart';
import 'package:plus90_application/utils/AppRoutes.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Approutes.splach,
      routes: {
        Approutes.splach: (context) => (SplachScreen()),
        Approutes.onborading: (context) => (Onboradingpages()),
        Approutes.auth: (context) => (Auth()),
        Approutes.login: (context) => (Login()),
        Approutes.registers: (context) => (Registers()),
        Approutes.Choosetype: (context) => (Choosetype()),
        Approutes.Home: (context) => (Home()),
      },
    );
  }
}
