import 'package:flutter/material.dart';
import 'package:plus90_application/screens/myitem/card.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';

class MyItems extends StatelessWidget {
  const MyItems({super.key});
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.offwhite,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.01,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Image.asset(AppAssets.myitems),
                SizedBox(height: height(context) * 0.01),
                ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: width(context) * 0.015,
                    ),
                    child: CardMyItem(),
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
