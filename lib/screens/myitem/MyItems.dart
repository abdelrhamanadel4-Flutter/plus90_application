import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/screens/myitem/card.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';

class MyItems extends StatelessWidget {
  const MyItems({super.key});

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColor.offwhite,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deals')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          // ✅ شيل الـ deals اللي stock بتاعها 0
          final deals = (snapshot.data?.docs ?? []).where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final stock = (data['stock'] as num?)?.toInt() ?? 1;
            return stock > 0;
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: width(context) * 0.04,
              vertical: height(context) * 0.01,
            ),
            itemCount: deals.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Image.asset(AppAssets.myitems),
                    SizedBox(height: height(context) * 0.01),
                    if (deals.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          "No deals yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                );
              }

              final data = deals[index - 1].data() as Map<String, dynamic>;

              DateTime? expiryDate;
              if (data['expiry'] != null) {
                expiryDate = DateTime.tryParse(data['expiry']);
              }

              List<String> imageUrls = [];
              if (data['images'] is List) {
                imageUrls = (data['images'] as List)
                    .map((e) => e.toString())
                    .toList();
              }

              return Padding(
                padding: EdgeInsets.symmetric(vertical: width(context) * 0.015),
                child: CardMyItem(
                  id: deals[index - 1].id,
                  title: data['title'] ?? '',
                  location: data['location'] ?? '',
                  initialPrice: data['initialPrice'] ?? '0',
                  discountedPrice: data['discountedPrice'] ?? '0',
                  description: data['description'] ?? '',
                  stock: data['stock']?.toString() ?? '',
                  category: data['category'] ?? '',
                  imageUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
                  imageUrls: imageUrls,
                  expiryDate: expiryDate,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
