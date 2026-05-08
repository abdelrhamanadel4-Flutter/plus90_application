import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plus90_application/Auth/auth.dart';
import 'package:plus90_application/Auth/login.dart';
import 'package:plus90_application/Auth/registers.dart';
import 'package:plus90_application/Home/store/homeScrean_store.dart';
import 'package:plus90_application/Home/user/homeScrean.dart';
import 'package:plus90_application/Home/user/tabs/cart/orderconfirmed.dart';
import 'package:plus90_application/Splach/splachScrean.dart';
import 'package:plus90_application/firebase_options.dart';
import 'package:plus90_application/onBorading/onboradingpages.dart';
import 'package:plus90_application/screens/AddItem.dart';
import 'package:plus90_application/screens/catgory.dart';
import 'package:plus90_application/screens/deatils_scean.dart';
import 'package:plus90_application/screens/myorders.dart';
import 'package:plus90_application/screens/sell_screen.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app.theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(MyApp());
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
        Approutes.HomeScreen: (context) => (HomeScreen()),
        Approutes.HomescreanStore: (context) => (HomescreanStore()),
        Approutes.DeatilsScrean: (context) => (DeatilsScrean()),
        Approutes.Myorders: (context) => (Myorders()),
        Approutes.Categories: (context) => (Categories()),
        Approutes.orderconfirmed: (context) => (OrderConfirmed()),
        Approutes.SellScreen: (context) => (SellScreen()),
        Approutes.AddItem: (context) => (AddItem()),
      },
    );
  }
}
