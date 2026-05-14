import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class Myorders extends StatelessWidget {
  const Myorders({super.key});

  @override
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.offwhite,
        title: Text('Myorders', style: AppStyle.bold24black),
        leading: Row(
          children: [
            Spacer(),
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
        child: Expanded(
          child: StreamBuilder(
  stream: FirebaseFirestore.instance.collection("deals").snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text("No Deals Found"));
    }

    final deals = snapshot.data!.docs;

    return ListView.builder(
      itemCount: deals.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
      itemBuilder: (context, index) {
        final data = deals[index].data();
        final doc = deals[index];
        final id = doc.id;

        return Padding(
          padding: EdgeInsets.only(bottom: height(context) * 0.015),
          child: CardItem(dealData: data,
          id: id,), // 🔥 هنا بنبعت الداتا من Firestore
        );
      },
    );
  },
),
        ),
      ),
    );
  }
}
