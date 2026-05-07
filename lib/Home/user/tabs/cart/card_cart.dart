import 'package:flutter/material.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class CardCart extends StatefulWidget {
  const CardCart({super.key});

  @override
  State<CardCart> createState() => _CardCartState();
}

class _CardCartState extends State<CardCart> {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width(context) * 0.03,
        vertical: height(context) * 0.02,
      ),

      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 251, 251),
        borderRadius: BorderRadius.circular(15),

        boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// image
          Stack(
            children: [
              Image.asset(AppAssets.logo, height: height(context) * 0.1),

              Positioned(
                top: 0,
                left: 0,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Text('-50%', style: AppStyle.bold12white),
                ),
              ),
            ],
          ),

          SizedBox(width: width(context) * 0.03),

          /// details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// title + delete
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Text(
                        '5-Star Restaurant Dinner for Two',
                        style: AppStyle.semibold14black,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(width: width(context) * 0.02),

                    /// delete button
                    GestureDetector(
                      onTap: () {
                        DialogUtils.showMessage(
                          context: context,
                          message: 'Are you sure?',
                          posAction: () {},
                          posActionName: 'yes',
                          title: 'Delete  Item',
                        );

                        /// delete item
                      },

                      child: Container(
                        padding: const EdgeInsets.all(6),

                        decoration: BoxDecoration(
                          color: AppColor.orange,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColor.whiteColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.005),

                /// timer
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

                SizedBox(height: height(context) * 0.005),

                /// price + quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    /// prices
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          '\$150',
                          style: AppStyle.medium14ramdi.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                        Text('\$75', style: AppStyle.bold20orange),
                      ],
                    ),

                    /// quantity
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            count = count > 1 ? count - 1 : 1;

                            setState(() {});
                          },

                          child: Image.asset(
                            AppAssets.Button,
                            height: height(context) * 0.03,
                          ),
                        ),

                        SizedBox(width: width(context) * 0.02),

                        Text('$count', style: AppStyle.bold12orange),

                        SizedBox(width: width(context) * 0.02),

                        GestureDetector(
                          onTap: () {
                            count++;

                            setState(() {});
                          },

                          child: Image.asset(
                            AppAssets.Button2,
                            height: height(context) * 0.03,
                          ),
                        ),
                      ],
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
