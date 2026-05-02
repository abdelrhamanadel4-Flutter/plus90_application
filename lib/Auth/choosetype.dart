import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Auth/card.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class Choosetype extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  Choosetype({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<Choosetype> createState() => _ChoosetypeState();
}

class _ChoosetypeState extends State<Choosetype> {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: height(context) * 0.03),

              Text('How will you use +90?', style: AppStyle.bold24black),

              SizedBox(height: height(context) * 0.01),

              Text(
                'Choose the account type that fits your needs. You can’t change this later',
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
                text: 'Get Started',
                textStyle: AppStyle.semibold20white,

                onPressed: () async {
                  try {
                    var user = FirebaseAuth.instance.currentUser;

                    print("user: $user");

                    if (user == null) {
                      DialogUtils.showMessage(
                        context: context,
                        title: "Error",
                        message: "No user logged in",
                      );
                      return;
                    }

                    if (selectedIndex == -1) {
                      DialogUtils.showMessage(
                        context: context,
                        title: "Warning",
                        message: "Please select account type",
                      );
                      return;
                    }

                    // Show loading
                    DialogUtils.showLoading(
                      context: context,
                      loadingText: "Saving data...",
                    );

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                          "name": widget.name,
                          "email": widget.email,
                          "phone": widget.phone,
                          "accountType": selectedIndex == 0 ? "user" : "store",
                        });

                    // Hide loading
                    DialogUtils.hideLoading(context: context);

                    print("done firestore");

                    // Navigate
                    Navigator.pushReplacementNamed(context, Approutes.login);
                  } catch (e) {
                    DialogUtils.hideLoading(context: context);

                    print("ERROR: $e");

                    DialogUtils.showMessage(
                      context: context,
                      title: "Error",
                      message: e.toString(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
