import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:plus90_application/Home/store/homestore.dart';

import 'package:plus90_application/Home/user/tabs/profile/profile.dart';
import 'package:plus90_application/screens/incomingorder/IncomingOrder.dart';
import 'package:plus90_application/screens/myitem/MyItems.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';

class HomescreanStore extends StatefulWidget {
  const HomescreanStore({super.key});

  @override
  State<HomescreanStore> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomescreanStore>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<Widget> pages = [
    Homestore(),
    IncomingOrder(),
    MyItems(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);

    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: BottomBar(
        layout: BottomBarLayout(
          width: MediaQuery.of(context).size.width * 0.88,
          borderRadius: BorderRadius.circular(35),
        ),

        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),

        child: Container(
          height: 72,

          decoration: BoxDecoration(
            color: AppColor.orange,
            borderRadius: BorderRadius.circular(35),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              /// home
              navItem(index: 0, image: AppAssets.home),

              /// search
              navItem(index: 1, image: AppAssets.incomingorder),

              /// center button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Approutes.AddItem);

                  /// action
                },

                child: Transform.translate(
                  offset: const Offset(0, -18),

                  child: Container(
                    height: 60,
                    width: 60,

                    decoration: BoxDecoration(
                      color: AppColor.orange,
                      shape: BoxShape.circle,

                      border: Border.all(color: Colors.white, width: 5),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),

              /// cart
              navItem(index: 2, image: AppAssets.actrivemorder),

              /// profile
              navItem(index: 3, image: AppAssets.profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem({required int index, required String image}) {
    final bool isSelected = tabController.index == index;

    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image.asset(
            image,
            height: 24,
            width: 24,
            color: isSelected ? AppColor.offwhite : Color(0xFFE5C7D1),
          ),

          const SizedBox(height: 6),

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),

            height: 3,

            width: isSelected ? 20 : 0,

            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
