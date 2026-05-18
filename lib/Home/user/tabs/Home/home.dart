import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/Home/user/tabs/Home/seeall_expringsoon.dart';
import 'package:plus90_application/Home/user/tabs/Home/seeall_storesnear.dart';
import 'package:plus90_application/screens/notfication/NotificationBell.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app_color.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  late final PageController _controller;
  int _currentPage = 1;
  double? userLat;
  double? userLng;

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  late final List<Widget> banners;

  @override
  void initState() {
    super.initState();
    banners = [_banner3(), _banner1(), _banner2(), _banner3(), _banner1()];
    _controller = PageController(initialPage: _currentPage);
    _autoSlide();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        userLat = (doc.data()?['lat'] as num?)?.toDouble();
        userLng = (doc.data()?['lng'] as num?)?.toDouble();
      });
    }
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const R = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRad(double deg) => deg * pi / 180;

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

  String _timeLeft(DateTime expiry) {
    final diff = expiry.difference(DateTime.now());
    if (diff.inDays > 0) return "${diff.inDays}d left";
    if (diff.inHours > 0) return "${diff.inHours}h left";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m left";
    return "Expiring now";
  }

  Color _badgeColor(DateTime expiry) {
    final diff = expiry.difference(DateTime.now());
    if (diff.inHours < 6) return Colors.red;
    if (diff.inHours < 24) return Colors.orange;
    return const Color(0xFF861E43);
  }

  void _goToCategory(String categoryName) {
    Navigator.pushReplacementNamed(
      context,
      Approutes.Categories,
      arguments: categoryName,
    );
  }

  bool _isValidDeal(Map<String, dynamic> data) {
    final expiry = data['expiry'];
    if (expiry == null) return false;
    final expiryDate = DateTime.tryParse(expiry);
    if (expiryDate == null) return false;
    if (expiryDate.isBefore(DateTime.now())) return false;

    // ✅ بيتعامل مع num وString وnull
    final stockRaw = data['stock'];
    final stock = num.tryParse(stockRaw?.toString() ?? '0') ?? 0;
    if (stock <= 0) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  /// top bar
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
                      const NotificationBell(),
                    ],
                  ),

                  const SizedBox(height: 15),
                  const SizedBox(height: 15),

                  /// banner
                  SizedBox(
                    height: 120,
                    child: PageView(controller: _controller, children: banners),
                  ),

                  const SizedBox(height: 20),

                  /// expiring soon
                  sectionTitle(
                    "Expiring Soon",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AllExpiringSoonScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("deals")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 170,
                          width: 10000,

                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (_, __) => Container(
                              width: 260,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      var deals = snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return _isValidDeal(data);
                      }).toList();

                      deals.sort((a, b) {
                        final dataA = a.data() as Map<String, dynamic>;
                        final dataB = b.data() as Map<String, dynamic>;
                        final expiryA = DateTime.parse(dataA['expiry']);
                        final expiryB = DateTime.parse(dataB['expiry']);
                        return expiryA.compareTo(expiryB);
                      });

                      final top4 = deals.take(4).toList();

                      if (top4.isEmpty) return const SizedBox.shrink();

                      return SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: top4.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final data =
                                top4[index].data() as Map<String, dynamic>;
                            final id = top4[index].id;
                            final expiryDate = DateTime.parse(data['expiry']);

                            return SizedBox(
                              width: 260,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 12,
                                        color: _badgeColor(expiryDate),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        _timeLeft(expiryDate),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _badgeColor(expiryDate),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: CardItem(
                                      dealData: {...data, 'id': id},
                                      id: id,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// categories
                  sectionTitle(
                    "Categories",
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Approutes.Categories,
                        arguments: "All",
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 20),
                        category(
                          icon: Icons.local_offer,
                          label: "Offers",
                          categoryKey: "Offers",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 25),
                        category(
                          icon: Icons.restaurant,
                          label: "Restaurants & Cafes",
                          categoryKey: "Restaurants & Cafes",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 25),
                        category(
                          icon: Icons.checkroom,
                          label: "Fashion",
                          categoryKey: "Fashion",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 25),
                        category(
                          icon: Icons.spa,
                          label: "Beauty & Care",
                          categoryKey: "Beauty & Care",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 25),
                        category(
                          icon: Icons.home_repair_service,
                          label: "Home Services",
                          categoryKey: "Home Services",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 25),
                        category(
                          icon: Icons.devices,
                          label: "Electronics",
                          categoryKey: "Electronics",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 25),
                        category(
                          icon: Icons.event,
                          label: "Events",
                          categoryKey: "Events",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 25),
                        category(
                          icon: Icons.directions_car,
                          label: "Automotive",
                          categoryKey: "Automotive",
                          onTap: _goToCategory,
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// stores nearby
                  sectionTitle(
                    "Stores Nearby",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllStoresNearbyScreen(
                            userLat: userLat,
                            userLng: userLng,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("deals")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No Deals Found"));
                      }

                      var deals = snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return _isValidDeal(data);
                      }).toList();

                      if (userLat != null && userLng != null) {
                        deals.sort((a, b) {
                          final dataA = a.data() as Map<String, dynamic>;
                          final dataB = b.data() as Map<String, dynamic>;

                          final latA = (dataA['lat'] as num?)?.toDouble() ?? 0;
                          final lngA = (dataA['lng'] as num?)?.toDouble() ?? 0;
                          final latB = (dataB['lat'] as num?)?.toDouble() ?? 0;
                          final lngB = (dataB['lng'] as num?)?.toDouble() ?? 0;

                          final distA = _calculateDistance(
                            userLat!,
                            userLng!,
                            latA,
                            lngA,
                          );
                          final distB = _calculateDistance(
                            userLat!,
                            userLng!,
                            latB,
                            lngB,
                          );

                          return distA.compareTo(distB);
                        });
                      }

                      if (deals.isEmpty) {
                        return const Center(
                          child: Text("No Active Deals Found"),
                        );
                      }

                      return ListView.builder(
                        itemCount: deals.length < 5 ? deals.length : 5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                        ),
                        itemBuilder: (context, index) {
                          final data =
                              deals[index].data() as Map<String, dynamic>;
                          final id = deals[index].id;

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: height(context) * 0.015,
                            ),
                            child: CardItem(
                              dealData: {...data, 'id': id},
                              id: id,
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          colors: [Color(0xFF861E43), Color(0xFF97B6B1)],
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

  Widget sectionTitle(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF861E43),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            "See All",
            style: TextStyle(
              color: Color(0xFF861E43),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF861E43),
            ),
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

  static Widget category({
    required IconData icon,
    required String label,
    required String categoryKey,
    required void Function(String) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(categoryKey),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFDEE2DC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColor.orange),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF861E43),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
