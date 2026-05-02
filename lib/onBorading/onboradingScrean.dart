import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboradingscrean extends StatelessWidget {
  Onboradingscrean({
    super.key,
    required this.title,
    required this.text,
    required this.image,
    required this.controller,
  });
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;
  String title;
  String text;
  String image;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: height(context) * 0.07,
            left: width(context) * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.rammettoOne(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height(context) * 0.01),
              Text(
                textAlign: TextAlign.center,
                text,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(height: height(context) * 0.04),

              Center(
                child: SmoothPageIndicator(
                  controller: controller, // PageController
                  count: 4,

                  effect: ExpandingDotsEffect(
                    dotWidth: 11,
                    dotHeight: 11,
                    activeDotColor: const Color.fromARGB(255, 255, 255, 255),
                    dotColor: const Color.fromARGB(137, 255, 255, 255),
                  ), // your preferred effect
                  onDotClicked: (index) {
                    controller.animateToPage(
                      index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
