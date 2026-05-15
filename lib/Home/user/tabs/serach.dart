import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom_text_from.dart';


class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.07,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextFormField(
              contentPadding: EdgeInsets.symmetric(
                horizontal: width(context) * 0.04,
                vertical: height(context) * 0.02,
              ),
              hint: 'Search deals, restaurants, activities...',
              hintStyle: AppStyle.medium14ramdi,
              prefixIcon: Image.asset(
                AppAssets.icon_search,
                height: height(context) * 0.007,
              ),
              borderColor: AppColor.grayColor,
              fillColor: AppColor.whiteColor,
            ),

            Expanded(
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
          ],
        ),
      ),
    );
  }
}
