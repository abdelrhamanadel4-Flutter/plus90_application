import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class Myorders extends StatelessWidget {
  @override
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.offwhite,
        title: Text('Myorders', style: AppStyle.bold24black),
        leading: Row(
          children: [
            Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.blackColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.02,
        ),
        child: Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: width(context) * 0.015),
              child: CardItem(),
            ),
            itemCount: 5,
          ),
        ),
      ),
    );
  }
}
