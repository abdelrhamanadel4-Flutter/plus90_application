import 'package:flutter/material.dart';
import 'package:plus90_application/screens/search_screen.dart';
import 'package:plus90_application/screens/cart_screen.dart';
import 'package:plus90_application/screens/profile_screen.dart';
import 'package:plus90_application/screens/scan_screen.dart';
import 'package:plus90_application/screens/sell_screen.dart';
import 'package:plus90_application/screens/notification_screen.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  late final PageController _controller;
  int _currentPage = 1;
  int _selectedIndex = 0;

  late final List<Widget> banners;

  @override
  void initState() {
    super.initState();

    //علشان البانر تبقي بتبدأ من الاول تاني

    // Fake first & last for infinite loop
    banners = [
      _banner3(), // fake first
      _banner1(),
      _banner2(),
      _banner3(),
      _banner1(), // fake last
    ];

    _controller = PageController(initialPage: _currentPage);

    _autoSlide();
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      _currentPage++;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );

      _handleLoop();

      _autoSlide();
    });
  }

  //لحركه البانر
  void _handleLoop() {
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;

      if (_currentPage == banners.length - 1) {
        _controller.jumpToPage(1);
        _currentPage = 1;
      }

      if (_currentPage == 0) {
        _controller.jumpToPage(banners.length - 2);
        _currentPage = banners.length - 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      // زرار sell now
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SellScreen()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE12C00),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.crop_free, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Sell Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Top bar فيه اللوجو والاشعارات
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
                          colors: [Color(0xFFE12C00), Color(0xFF97B6B1)],
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
                          color: Color(0xFFE12C00),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Search
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search deals, restaurants, activities...",
                    prefixIcon: const Icon(
                      Icons.search_outlined,
                      color: Color(0xFFE12C00),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFE12C00)),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                //  INFINITE BANNER
                SizedBox(
                  height: 120,
                  child: PageView(controller: _controller, children: banners),
                ),

                const SizedBox(height: 20),

                sectionTitle("Expiring Soon"),
                const SizedBox(height: 10),

                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => greyCard(),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: 10,
                  ),
                ),

                const SizedBox(height: 20),

                //Categories
                sectionTitle("Categories"),
                const SizedBox(height: 10),

                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 20),
                      category(icon: Icons.fastfood, label: "Food"),
                      const SizedBox(width: 25),
                      category(
                        icon: Icons.local_mall,
                        label: "Health & Beauty",
                      ),
                      const SizedBox(width: 25),
                      category(icon: Icons.pets, label: "Pet Supplies"),
                      const SizedBox(width: 25),
                      category(icon: Icons.shopify, label: "Entertainment"),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                sectionTitle("Stores Nearby"),
                const SizedBox(height: 10),

                storeCard(),
                const SizedBox(height: 10),
                storeCard(),

                const SizedBox(height: 20),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 2) return;

              setState(() {
                _selectedIndex = index;
              });

              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              } else if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
            },

            //bottom nav design
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFE12C00),
            unselectedItemColor: Colors.blueGrey.shade200,
            showUnselectedLabels: true,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(icon: SizedBox(), label: ""),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
          // الزرار للي بيفتح ال scan screen
          Positioned(
            bottom: 25,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanScreen()),
                );
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFE12C00),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.20),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.center_focus_strong,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== BANNERS =====
  static Widget _banner1() {
    return _banner(
      "Save Big, Waste Less\nUp to 70% off on near-expiry products",
    );
  }

  static Widget _banner2() {
    return _banner("Fresh Deals Every Day\nGrab your favorite items now!");
  }

  static Widget _banner3() {
    return _banner("Fast Delivery 🚀\nGet your order in minutes");
  }

  static Widget _banner(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFFE12C00), Color(0xFF97B6B1)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.phone_android, color: Colors.white, size: 50),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE12C00),
          ),
        ),
        const Text(
          "See All",
          style: TextStyle(
            color: Color(0xFFE12C00),
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFFE12C00),
          ),
        ),
      ],
    );
  }

  Widget greyCard() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static Widget category({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE12C00),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE12C00),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget storeCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade200,
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Luxury Spa Package",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0D6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "-40%",
                  style: TextStyle(
                    color: Color(0xFFE12C00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Grand Hotel, 2.5km away",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text(
                "\$120.00",
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "\$72.00",
                style: TextStyle(
                  color: Color(0xFFE12C00),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
