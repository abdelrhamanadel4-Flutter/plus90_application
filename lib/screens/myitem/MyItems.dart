import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      backgroundColor: AppColor.offwhite,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.01,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Image.asset(AppAssets.myitems),
                SizedBox(height: height(context) * 0.01),

                /// ✅ StreamBuilder بيجيب الديلز من Firestore real-time
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('deals')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    /// loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    /// error
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }

                    /// empty
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "No deals yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    final deals = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: deals.length,
                      itemBuilder: (context, index) {
                        final data =
                            deals[index].data() as Map<String, dynamic>;

                        /// تحويل expiry من String لـ DateTime
                        DateTime? expiryDate;
                        if (data['expiry'] != null) {
                          expiryDate = DateTime.tryParse(data['expiry']);
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: width(context) * 0.015,
                          ),
                          child: CardMyItem(
                            title: data['title'] ?? '',
                            location: data['location'] ?? '',
                            initialPrice: data['initialPrice'] ?? '0',
                            discountedPrice: data['discountedPrice'] ?? '0',
                            imageUrl: (data['images'] as List?)?.isNotEmpty == true
                                ? data['images'][0]
                                : null,
                            expiryDate: expiryDate,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}