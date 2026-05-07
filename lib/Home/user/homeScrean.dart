import 'package:flutter/material.dart';
import 'package:plus90_application/Home/user/tabs/cart/cart.dart';
import 'package:plus90_application/Home/user/tabs/home.dart';
import 'package:plus90_application/Home/user/tabs/profile.dart';
import 'package:plus90_application/Home/user/tabs/serach.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/screens/sell_screen.dart';

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
      floatingActionButton: Container(
        height: 60,
        width: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.orange,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SellScreen()),
            );
          },
          backgroundColor: AppColor.orange,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.store, color: Colors.white, size: 32),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.offwhite,
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
    );
  }
}
