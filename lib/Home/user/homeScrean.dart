import 'package:flutter/material.dart';
import 'package:plus90_application/Home/user/tabs/cart/cart.dart';
import 'package:plus90_application/Home/user/tabs/home.dart';
import 'package:plus90_application/Home/user/tabs/profile.dart';
import 'package:plus90_application/Home/user/tabs/serach.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _pages = [HomeUI(), SearchTab(), CartTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.home,
                color: _selectedIndex == 0
                    ? AppColor.orange
                    : AppColor.grayColor2,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.search,
                color: _selectedIndex == 1
                    ? AppColor.orange
                    : AppColor.grayColor2,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.cart,
                color: _selectedIndex == 2
                    ? AppColor.orange
                    : AppColor.grayColor2,
              ),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.profile,
                color: _selectedIndex == 3
                    ? AppColor.orange
                    : AppColor.grayColor2,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
