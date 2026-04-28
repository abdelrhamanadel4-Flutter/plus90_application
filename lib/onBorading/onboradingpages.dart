import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plus90_application/onBorading/onboradingScrean.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';

class Onboradingpages extends StatefulWidget {
  const Onboradingpages({super.key});

  @override
  State<Onboradingpages> createState() => _OnboradingpagesState();
}

class _OnboradingpagesState extends State<Onboradingpages> {
  final PageController controller = PageController();
  int currentPage = 0;
  bool showNext = false;

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
                showNext = false;
              });

              if (index == 3) {
                Future.delayed(Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() {
                      showNext = true;
                    });
                  }
                });
              }
            },
            children: [
              Onboradingscrean(
                title: 'Shop Smart, Save More',
                text: 'Discover exclusive last-minute deals near you.',
                image: AppAssets.onborading1,
                controller: controller,
              ),
              Onboradingscrean(
                title: 'Deals Around You',
                text: 'Find offers nearby with real-time location tracking.',
                image: AppAssets.onborading2,
                controller: controller,
              ),
              Onboradingscrean(
                title: 'Limited Time Deals',
                text: 'Grab exclusive offers before they expire.',
                image: AppAssets.onborading3,
                controller: controller,
              ),
              Onboradingscrean(
                title: 'Fast & Easy Pickup',
                text: 'Grab your deal before it’s gone.',
                image: AppAssets.onborading4,
                controller: controller,
              ),
            ],
          ),

          if (currentPage == 3 && showNext)
            Positioned(
              bottom: height(context) * 0.05,
              right: width(context) * 0.05,
              child: ElevatedButton(
                style: ButtonStyle(),
                onPressed: () {
                  Navigator.pushNamed(context, Approutes.auth);
                  // Navigate to the next screen
                },
                child: Text(
                  "Next",
                  style: GoogleFonts.ramaraja(color: Color(0XFF861E43)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
