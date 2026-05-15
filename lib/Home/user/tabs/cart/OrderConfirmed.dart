import 'package:flutter/material.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class OrderConfirmed extends StatelessWidget {
  const OrderConfirmed({super.key});
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(context) * 0.04,
            vertical: height(context) * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppAssets.orderconfirmed, height: 250, width: 300),
              Center(
                child: Text('Order Confirmed!', style: AppStyle.bold20orange),
              ),
              SizedBox(height: height(context) * 0.01),
              Text(
                'Please wait for the product owner\'s confirmation.!',
                textAlign: TextAlign.center,
                style: AppStyle.medium14ramdi,
              ),
              SizedBox(height: height(context) * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.02,
                  vertical: height(context) * 0.02,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.02,
                          vertical: height(context) * 0.01,
                        ),
                        child: Row(
                          children: [
                            Text('Order ID', style: AppStyle.medium14ramdi),
                            Spacer(),
                            Text('#SAH12894', style: AppStyle.semibold14orange),
                          ],
                        ),
                      ),
                      Divider(),
                      buildInfoItem(
                        context,
                        icon: Icons.storefront_outlined,
                        title: 'Total Paid',
                        subtitle: '250 EGP',
                      ),

                      SizedBox(height: height(context) * 0.03),

                      /// method
                      buildInfoItem(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        title: 'Payment Method',
                        subtitle: 'Cash on Delivery',
                      ),

                      SizedBox(height: height(context) * 0.03),

                      /// date
                      buildInfoItem(
                        context,
                        icon: Icons.calendar_month_outlined,
                        title: 'Order Status',
                        subtitle: 'Waiting for Approval',
                      ),

                      SizedBox(height: height(context) * 0.03),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height(context) * 0.03),

              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Approutes.HomeScreen);
                },
                text: 'Back To Home',
                textStyle: AppStyle.semibold20white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildInfoItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
      /// icon
      Container(
        height: width(context) * 0.12,
        width: width(context) * 0.12,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.whiteColor,
        ),

        child: Icon(icon, color: AppColor.orange, size: width(context) * 0.06),
      ),

      SizedBox(width: width(context) * 0.04),

      /// text
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: width(context) * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: height(context) * 0.001),

            Text(
              subtitle,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
