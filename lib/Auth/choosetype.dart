import 'package:flutter/material.dart';
import 'package:plus90_application/Auth/card.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class Choosetype extends StatefulWidget {
  const Choosetype({super.key});

  @override
  State<Choosetype> createState() => _ChoosetypeState();
}

class _ChoosetypeState extends State<Choosetype> {
  height(context) => MediaQuery.of(context).size.height;
  int selectedIndex = -1;

  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.07),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: height(context) * 0.03),
              Text('How will you use +90?', style: AppStyle.bold24black),
              SizedBox(height: height(context) * 0.01),
              Text(
                'Choose the account type that fits your needs. You cant change this later',
                style: AppStyle.semibold14black,
              ),
              SizedBox(height: height(context) * 0.03),
              AccountCard(
                title: "Individual Account",
                subtitle: "User",
                isSelected: selectedIndex == 0,
                onTap: () {
                  setState(() => selectedIndex = 0);
                },
                features: [
                  "Buy & Sell: Browse deals or list items.",
                  "Community: Connect with people nearby.",
                  "Sustainability: Reduce waste.",
                ],
              ),

              AccountCard(
                title: "Business Account",
                subtitle: "Store",
                isSelected: selectedIndex == 1,
                onTap: () {
                  setState(() => selectedIndex = 1);
                },
                features: [
                  "Sell Only: List store products.",
                  "Verified Badge: Build trust.",
                  "Growth: Reach more customers.",
                ],
              ),
              SizedBox(height: height(context) * 0.02),
              CustomElevatedButton(
                onPressed: () {
                  if (selectedIndex == 0) {
                    Navigator.pushNamed(context, Approutes.HomeScreen);
                  } else {
                    // Show a message to select an account type
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select an account type')),
                    );
                  }
                },
                text: 'Get Started',
                textStyle: AppStyle.semibold20white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
