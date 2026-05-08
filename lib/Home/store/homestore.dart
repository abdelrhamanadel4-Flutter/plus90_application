import 'package:flutter/material.dart';
import 'package:plus90_application/screens/notification_screen.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';

class Homestore extends StatelessWidget {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.07,
        ),
        child: Column(
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
                  colors: [Color(0xFF861E43), Color(0xFFF8F8EB)],
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
                    child: Image.asset(AppAssets.icon_homestore, height: 100),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
