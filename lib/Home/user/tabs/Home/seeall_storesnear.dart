import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';

class AllStoresNearbyScreen extends StatefulWidget {
  AllStoresNearbyScreen({super.key, this.userLat, this.userLng});
  double? userLat;
  double? userLng;
  @override
  State<AllStoresNearbyScreen> createState() => AllStoresNearbyScreenState();
}

class AllStoresNearbyScreenState extends State<AllStoresNearbyScreen> {
  double? userLat;
  double? userLng;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF861E43).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF861E43),
              size: 18,
            ),
          ),
        ),
        title: const Text(
          "Stores Nearby",
          style: TextStyle(
            color: Color(0xFF861E43),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search stores...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF861E43),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Deals List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("deals")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF861E43),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _emptyState("No stores found");
                  }

                  final now = DateTime.now();

                  // فلتر الـ deals المنتهية
                  var deals = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final expiry = data['expiry'];
                    if (expiry == null) return false;
                    final expiryDate = DateTime.tryParse(expiry);
                    if (expiryDate == null) return false;
                    if (expiryDate.isBefore(now)) return false;
                    return true;
                  }).toList();

                  // رتب من الأقرب لو عندنا location اليوزر
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

                  // فلتر البحث
                  if (_searchQuery.isNotEmpty) {
                    deals = deals.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title = (data['title'] ?? '')
                          .toString()
                          .toLowerCase();
                      final storeName = (data['storeName'] ?? '')
                          .toString()
                          .toLowerCase();
                      final category = (data['category'] ?? '')
                          .toString()
                          .toLowerCase();
                      return title.contains(_searchQuery) ||
                          storeName.contains(_searchQuery) ||
                          category.contains(_searchQuery);
                    }).toList();
                  }

                  if (deals.isEmpty) {
                    return _emptyState("No results for \"$_searchQuery\"");
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // عدد النتائج
                      Text(
                        "${deals.length} store${deals.length != 1 ? 's' : ''} found",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Expanded(
                        child: ListView.builder(
                          itemCount: deals.length,
                          padding: EdgeInsets.only(bottom: height * 0.02),
                          itemBuilder: (context, index) {
                            final data =
                                deals[index].data() as Map<String, dynamic>;
                            final id = deals[index].id;

                            // احسب المسافة لعرضها
                            String? distanceText;
                            if (userLat != null && userLng != null) {
                              final lat =
                                  (data['lat'] as num?)?.toDouble() ?? 0;
                              final lng =
                                  (data['lng'] as num?)?.toDouble() ?? 0;
                              final dist = _calculateDistance(
                                userLat!,
                                userLng!,
                                lat,
                                lng,
                              );
                              distanceText = dist < 1
                                  ? "${(dist * 1000).toStringAsFixed(0)} m away"
                                  : "${dist.toStringAsFixed(1)} km away";
                            }

                            return Padding(
                              padding: EdgeInsets.only(bottom: height * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Distance badge
                                  if (distanceText != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 14,
                                            color: Color(0xFF861E43),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            distanceText,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF861E43),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  CardItem(
                                    dealData: {...data, 'id': id},
                                    id: id,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_mall_directory_outlined,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 15),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
