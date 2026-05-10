import 'package:flutter/material.dart';
import 'package:plus90_application/screens/notification_screen.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/Home/card_item.dart';

class Homestore extends StatelessWidget {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.01,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF861E43), Color(0xFF97B6B1)],
                        ),
                      ),
                      child: const Text(
                        "+90",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Color(0xFF861E43),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(context) * 0.02),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF861E43),
                        Color.fromARGB(255, 181, 181, 169),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Sales', style: AppStyle.medium20white),
                            SizedBox(height: height(context) * 0.006),
                            Text('12,450 EGP', style: AppStyle.medium16white),
                            SizedBox(height: height(context) * 0.01),

                            Text(
                              '+12% Vs Last Week',
                              style: AppStyle.medium16green,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width(context) * 0.0),
                      Expanded(
                        child: Image.asset(
                          AppAssets.icon_homestore,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: height(context) * 0.009),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 110,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColor.orange,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "New Orders",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "7",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 24,
                                  color: Color(0xff000000),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width(context) * 0.01),
                    Expanded(
                      child: Container(
                        height: 110,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColor.orange,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Active Deals",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 114, 198, 95),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "25",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.notifications_active_outlined,
                                  size: 24,
                                  color: Color.fromARGB(255, 114, 198, 95),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width(context) * 0.01),
                    Expanded(
                      child: Container(
                        height: 110,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColor.orange,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ends Soon",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 185, 167, 56),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "10",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.timelapse_outlined,
                                  size: 24,
                                  color: Color.fromARGB(255, 185, 167, 56),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width(context) * 0.01),
                    Expanded(
                      child: Container(
                        height: 110,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColor.orange,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Expired",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xffD70000),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "17",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 24,
                                  color: Color(0xffD70000),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width(context) * 0.01),
                  ],
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Active Now", style: AppStyle.bold20orange),
                ),

                ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: width(context) * 0.015,
                    ),
                    child: CardItem(),
                  ),
                  itemCount: 3,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
