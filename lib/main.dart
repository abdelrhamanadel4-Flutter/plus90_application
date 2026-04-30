import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plus90_application/Auth/auth.dart';
import 'package:plus90_application/Auth/choosetype.dart';
import 'package:plus90_application/Auth/login.dart';
import 'package:plus90_application/Auth/registers.dart';
import 'package:plus90_application/Home/homeScrean.dart';
import 'package:plus90_application/Splach/splachScrean.dart';
import 'package:plus90_application/firebase_options.dart';
import 'package:plus90_application/onBorading/onboradingpages.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app.theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(MyApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance.disableNetwork();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Approutes.splach,
      theme: Apptheme.darktheme,
      themeMode: ThemeMode.dark,
      routes: {
        Approutes.splach: (context) => (SplachScreen()),
        Approutes.onborading: (context) => (Onboradingpages()),
        Approutes.auth: (context) => (Auth()),
        Approutes.login: (context) => (Login()),
        Approutes.registers: (context) => (Registers()),
        Approutes.Choosetype: (context) => (Choosetype()),
        Approutes.HomeScreen: (context) => (HomeScreen()),
      },
    );
  }
}
