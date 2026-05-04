import 'package:flutter/material.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class CardItem extends StatefulWidget {
  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  bool isfav = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.grayColor3,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width(context) * 0.04,
        vertical: height(context) * 0.02,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(AppAssets.donut, fit: BoxFit.fill),
            ),
          ),
          SizedBox(width: width(context) * 0.04),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('Unicorn Sprinkles', style: AppStyle.bold18orange),
                    Spacer(),
                    GestureDetector(
                      child: Icon(
                        isfav ? Icons.favorite : Icons.favorite_border,
                        color: AppColor.orange,
                      ),
                      onTap: () {
                        setState(() {
                          isfav = !isfav;
                        });
                        DialogUtils.showMessage(
                          context: context,
                          message: isfav
                              ? "Added to favorites"
                              : "Remove from favorites",
                        );

                        // Handle favorite action
                      },
                    ),
                  ],
                ),
                SizedBox(height: height(context) * 0.01),
                Text('Grand Hotel, 2.5km away', style: AppStyle.medium14ramdi),
                SizedBox(height: height(context) * 0.01),
                Row(
                  children: [
                    Text('\$72.00', style: AppStyle.bold20orange),
                    Spacer(),
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.clock,
                          height: height(context) * 0.015,
                        ),
                        SizedBox(width: width(context) * 0.01),
                        Text('08:15:29', style: AppStyle.bold12orange),
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$150',
                  style: AppStyle.medium14ramdi.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Approutes.DeatilsScrean);
                  },
                  child: Row(
                    children: [
                      Text('View Details', style: AppStyle.medium14orange),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColor.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
