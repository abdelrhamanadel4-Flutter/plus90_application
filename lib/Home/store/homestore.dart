import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/screens/notification_screen.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/Home/card_item.dart';

class Homestore extends StatefulWidget {
  const Homestore({super.key});

  @override
  State<Homestore> createState() => _HomestoreState();
}

class _HomestoreState extends State<Homestore> {
  double get _h => MediaQuery.of(context).size.height;
  double get _w => MediaQuery.of(context).size.width;

  List<QueryDocumentSnapshot> _lastActiveDocs = [];
  int _lastNewCount = 0;
  int _lastActiveCount = 0;
  int _lastEndsSoonCount = 0;
  int _lastExpiredCount = 0;
  int _lastTotalCount = 0;

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String _getStatus(dynamic expiry) {
    DateTime? expiryDate = _parseDate(expiry);
    if (expiryDate == null) return 'expired';
    final now = DateTime.now();
    if (expiryDate.isBefore(now)) return 'expired';
    final diff = expiryDate.difference(now);
    if (diff.inHours <= 24) return 'endsSoon';
    return 'active';
  }

  bool _isNew(dynamic createdAt) {
    DateTime? date = _parseDate(createdAt);
    if (date == null) return false;
    return DateTime.now().difference(date).inHours <= 24;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text("Please Login")));

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deals')
            .where('storeId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            _lastActiveDocs = [];
            _lastNewCount = 0;
            _lastActiveCount = 0;
            _lastEndsSoonCount = 0;
            _lastExpiredCount = 0;
            _lastTotalCount = snapshot.data!.docs.length;

            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final status = _getStatus(data['expiry']);

              // ✅ بيعد New بس لو مش expired
              if (_isNew(data['createdAt']) && status != 'expired') _lastNewCount++;

              if (status == 'active') {
                _lastActiveCount++;
                _lastActiveDocs.add(doc);
              } else if (status == 'endsSoon') {
                _lastEndsSoonCount++;
                _lastActiveDocs.add(doc);
              } else {
                _lastExpiredCount++;
              }
            }
          }

          final isFirstLoad =
              snapshot.connectionState == ConnectionState.waiting &&
              _lastActiveDocs.isEmpty &&
              _lastTotalCount == 0;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _w * 0.04,
              vertical: _h * 0.01,
            ),
            child: ListView(
              children: [
                Column(
                  children: [
                    // ── Header ─────────────────────────────────
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

                    SizedBox(height: _h * 0.02),

                    // ── Total Deals Card ────────────────────────
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
                                SizedBox(height: _h * 0.006),
                                Text(
                                  isFirstLoad ? '...' : '$_lastTotalCount Deals',
                                  style: AppStyle.medium16white,
                                ),
                                SizedBox(height: _h * 0.01),
                                Text(
                                  '${_lastActiveCount + _lastEndsSoonCount} Active',
                                  style: AppStyle.medium16green,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: _w * 0.0),
                          Expanded(
                            child: Image.asset(
                              AppAssets.icon_homestore,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Stats Cards ─────────────────────────────
                    Row(
                      children: [
                        // New Deals
                        Expanded(
                          child: Container(
                            height: 110,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColor.orange, width: 2.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "New Deals",
                                  style: TextStyle(fontSize: 12, color: Color(0xff000000), fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isFirstLoad ? '...' : '$_lastNewCount',
                                      style: const TextStyle(fontSize: 24, color: Color(0xff000000), fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.shopping_bag_outlined, size: 24, color: Color(0xff000000)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: _w * 0.01),

                        // Active Deals
                        Expanded(
                          child: Container(
                            height: 110,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColor.orange, width: 2.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Active Deals",
                                  style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 114, 198, 95), fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isFirstLoad ? '...' : '${_lastActiveCount + _lastEndsSoonCount} ',
                                      style: const TextStyle(fontSize: 24, color: Color(0xff000000), fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.notifications_active_outlined, size: 24, color: Color.fromARGB(255, 114, 198, 95)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: _w * 0.01),

                        // Ends Soon
                        Expanded(
                          child: Container(
                            height: 110,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColor.orange, width: 2.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Ends Soon",
                                  style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 185, 167, 56), fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isFirstLoad ? '...' : '$_lastEndsSoonCount',
                                      style: const TextStyle(fontSize: 24, color: Color(0xff000000), fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.timelapse_outlined, size: 24, color: Color.fromARGB(255, 185, 167, 56)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: _w * 0.01),

                        // Expired
                        Expanded(
                          child: Container(
                            height: 110,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColor.orange, width: 2.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Expired",
                                  style: TextStyle(fontSize: 12, color: Color(0xffD70000), fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isFirstLoad ? '...' : '$_lastExpiredCount',
                                      style: const TextStyle(fontSize: 24, color: Color(0xff000000), fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.cancel_outlined, size: 24, color: Color(0xffD70000)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: _w * 0.01),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Active Now", style: AppStyle.bold20orange),
                    ),

                    const SizedBox(height: 8),

                    // ── Active Deals List ───────────────────────
                    if (isFirstLoad)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(color: Color(0xFF861E43)),
                        ),
                      )
                    else if (_lastActiveDocs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            "No Active Deals",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount: _lastActiveDocs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: _w * 0.04),
                        itemBuilder: (context, index) {
                          final data = _lastActiveDocs[index].data() as Map<String, dynamic>;
                          final id = _lastActiveDocs[index].id;
                          return Padding(
                            padding: EdgeInsets.only(bottom: _h * 0.015),
                            child: CardItem(dealData: data, id: id),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}