import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';

class AllExpiringSoonScreen extends StatefulWidget {
  const AllExpiringSoonScreen({super.key});

  @override
  State<AllExpiringSoonScreen> createState() => _AllExpiringSoonScreenState();
}

class _AllExpiringSoonScreenState extends State<AllExpiringSoonScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _timeLeft(DateTime expiry) {
    final now = DateTime.now();
    final diff = expiry.difference(now);

    if (diff.inDays > 0) {
      return "${diff.inDays}d left";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h left";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m left";
    } else {
      return "Expiring now";
    }
  }

  Color _badgeColor(DateTime expiry) {
    final diff = expiry.difference(DateTime.now());
    if (diff.inHours < 6) return Colors.red;
    if (diff.inHours < 24) return Colors.orange;
    return const Color(0xFF861E43);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
          "Expiring Soon",
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
                  hintText: 'Search expiring deals...',
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

            /// List
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
                    return _emptyState("No deals found");
                  }

                  final now = DateTime.now();

                  var deals = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final expiry = data['expiry'];
                    if (expiry == null) return false;
                    final expiryDate = DateTime.tryParse(expiry);
                    if (expiryDate == null) return false;
                    if (expiryDate.isBefore(now)) return false;

                    // ✅ إخفاء المنتجات اللي stock = 0 أو مش موجود
                    final stock = data['stock'];
                    if (stock == null || (stock is num && stock <= 0))
                      return false;

                    return true;
                  }).toList();

                  deals.sort((a, b) {
                    final dataA = a.data() as Map<String, dynamic>;
                    final dataB = b.data() as Map<String, dynamic>;
                    final expiryA = DateTime.parse(dataA['expiry']);
                    final expiryB = DateTime.parse(dataB['expiry']);
                    return expiryA.compareTo(expiryB);
                  });

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
                    return _emptyState('No results for "$_searchQuery"');
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${deals.length} deal${deals.length != 1 ? 's' : ''} expiring soon",
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
                            final expiryDate = DateTime.parse(data['expiry']);

                            return Padding(
                              padding: EdgeInsets.only(bottom: height * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timer_outlined,
                                          size: 14,
                                          color: _badgeColor(expiryDate),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          _timeLeft(expiryDate),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _badgeColor(expiryDate),
                                            fontWeight: FontWeight.w600,
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
          Icon(Icons.hourglass_empty, size: 70, color: Colors.grey.shade300),
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
