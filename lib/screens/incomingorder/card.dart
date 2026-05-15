import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class Cardincomingorder extends StatelessWidget {
  const Cardincomingorder({super.key});

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width(context) * 0.03,
        vertical: height(context) * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColor.grayColor3,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          /// top section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// image
                  Container(
                    height: height(context) * 0.13,
                    width: width(context) * 0.28,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: AssetImage(AppAssets.donut),
                      ),
                    ),
                  ),

                  SizedBox(height: height(context) * 0.01),

                  SizedBox(
                    width: width(context) * 0.28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order #111', style: AppStyle.semibold14black),
                        SizedBox(height: height(context) * 0.004),
                        Text(
                          'Name: Menna Mohamed',
                          style: AppStyle.semibold14black,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(width: width(context) * 0.04),

              /// details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// title + timer
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Unicorn Sprinkles',
                            style: AppStyle.bold18orange,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.access_time_outlined,
                          color: AppColor.orange,
                          size: width(context) * 0.05,
                        ),
                        SizedBox(width: width(context) * 0.01),
                        Text('02:14:30', style: AppStyle.bold12orange),
                      ],
                    ),

                    SizedBox(height: height(context) * 0.01),

                    /// current price
                    Text('\$72.00', style: AppStyle.bold20orange),

                    SizedBox(height: height(context) * 0.004),

                    /// old price
                    Text(
                      '\$120.00',
                      style: AppStyle.medium14ramdi.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    SizedBox(height: height(context) * 0.015),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: x2', style: AppStyle.semibold14black),
                        SizedBox(height: height(context) * 0.004),
                        Text('Number For Delivery: 01123654598', style: AppStyle.semibold14black),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: height(context) * 0.025),

          /// buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// accept
              Container(
                width: width(context) * 0.32,
                padding: EdgeInsets.symmetric(
                  vertical: height(context) * 0.015,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7ED36E),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text('Accept', style: AppStyle.bold16white),
              ),

              /// reject
              Container(
                width: width(context) * 0.32,
                padding: EdgeInsets.symmetric(
                  vertical: height(context) * 0.015,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD90F16),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text('Reject', style: AppStyle.bold16white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
