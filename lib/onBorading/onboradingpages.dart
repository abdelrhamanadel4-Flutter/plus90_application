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
                title: 'Rescue, Don’t Waste',
                text:
                    'Join a community dedicated to saving the planet. Rescue near-expiry products and reduce food waste one deal at a time.',
                image: AppAssets.onborading1,
                controller: controller,
              ),
              Onboradingscrean(
                title: 'Smart Deals, Near You',
                text:
                    'Turn on your Radar to find incredible discounts of up to 70% on groceries, snacks, and tickets in your neighborhood.',
                image: AppAssets.onborading2,
                controller: controller,
              ),
              Onboradingscrean(
                title: 'Sell Faster, Earn Smarter',
                text:
                    'Have items you don’t need? Or stock that needs to move? List your products in seconds and reach buyers instantly.',
                image: AppAssets.onborading3,
                controller: controller,
              ),
              Onboradingscrean(
                title: 'Your Journey Starts Here',
                text:
                    'Ready to shop smart and sell easy? Join Sahlha today and discover the best deals around you.',
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
