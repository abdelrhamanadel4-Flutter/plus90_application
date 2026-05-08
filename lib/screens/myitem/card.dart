import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class CardMyItem extends StatefulWidget {
  const CardMyItem({super.key});

  @override
  State<CardMyItem> createState() => _CardMyItemState();
}

class _CardMyItemState extends State<CardMyItem> {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width(context) * 0.03,
        vertical: height(context) * 0.01,
      ),

      decoration: BoxDecoration(
        color: AppColor.grayColor3,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          /// image
          Container(
            height: height(context) * 0.12,
            width: width(context) * 0.26,

            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(18),

              image: DecorationImage(
                image: AssetImage(AppAssets.donut),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: width(context) * 0.035),

          /// details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// title + edit
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Text(
                        'Unicorn Sprinkles',
                        style: AppStyle.bold18orange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// edit icon
                    GestureDetector(
                      onTap: () {
                        /// edit action
                      },

                      child: Image.asset(
                        AppAssets.edit,
                        color: AppColor.orange,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.005),

                /// location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColor.grayColor2,
                      size: width(context) * 0.045,
                    ),

                    SizedBox(width: width(context) * 0.01),

                    Expanded(
                      child: Text(
                        'Grand Hotel, 2.5km away',
                        style: AppStyle.medium11ramdi,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.008),

                /// price + status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text('\$72.00', style: AppStyle.bold20orange),

                    const Spacer(),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.05,
                        vertical: height(context) * 0.008,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFF7ED36E),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        'Active',
                        style: AppStyle.bold12white.copyWith(
                          fontSize: width(context) * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.003),

                /// old price
                Text(
                  '\$120.00',
                  style: AppStyle.medium14ramdi.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

                SizedBox(width: width(context) * 0.03),

                SizedBox(height: height(context) * 0.01),

                /// timer
                Row(
                  children: [
                    Text(
                      'Ends In',
                      style: TextStyle(
                        color: Color(0xffD70000),
                        fontWeight: FontWeight.bold,
                        fontSize: width(context) * 0.045,
                      ),
                    ),

                    SizedBox(width: width(context) * 0.02),

                    Icon(
                      Icons.access_time_outlined,
                      color: Color(0xffD70000),
                      size: width(context) * 0.05,
                    ),

                    SizedBox(width: width(context) * 0.02),

                    Text(
                      '08:15:29',
                      style: TextStyle(
                        color: Color(0xffD70000),
                        fontWeight: FontWeight.bold,
                        fontSize: width(context) * 0.045,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
