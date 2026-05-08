import 'package:flutter/material.dart';
import 'package:plus90_application/Home/user/tabs/cart/card_cart.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(context) * 0.07,
            vertical: height(context) * 0.02,
          ),
          child: ListView(
            children: [
              /// 🔹 الهيدر
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Cart", style: AppStyle.bold20orange),
                      SizedBox(height: height(context) * 0.002),
                      Text(
                        "3 items in your cart",
                        style: AppStyle.medium11ramdi,
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset(
                    AppAssets.header_cart,
                    height: height(context) * 0.05,
                  ),
                ],
              ),

              SizedBox(height: height(context) * 0.03),

              ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: height(context) * 0.02),
                  child: CardCart(),
                ),
                itemCount: 3,

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),

              SizedBox(height: height(context) * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal", style: AppStyle.medium14ramdi),
                  Text("\$150.00", style: AppStyle.semibold14black),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Your Savings", style: AppStyle.medium14ramdi),
                  Text("-\$150.00", style: AppStyle.semibold14black),
                ],
              ),

              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: AppStyle.bold20black),
                  Text("\$150.00", style: AppStyle.bold20orange),
                ],
              ),
              SizedBox(height: height(context) * 0.03),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Approutes.orderconfirmed);
                },
                text: 'Checkout',
                textStyle: AppStyle.semibold20white,
              ),
              SizedBox(height: height(context) * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
