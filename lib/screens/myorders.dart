import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class Myorders extends StatelessWidget {
  const Myorders({super.key});

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.offwhite,
        title: Text('My Orders', style: AppStyle.bold24black),
        leading: Row(
          children: [
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.blackColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.02,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where(
                'userId',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid,
              ) // ✅ الفلتر
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Orders Found"));
            }

            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final data = orders[index].data() as Map<String, dynamic>;
                final id = orders[index].id;

                return Padding(
                  padding: EdgeInsets.only(bottom: height(context) * 0.015),
                  child: CardItem(dealData: data, id: id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
