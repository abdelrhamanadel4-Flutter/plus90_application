import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/Provider/fav_provider.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class Favdeals extends StatelessWidget {
  const Favdeals({super.key});

  double height(context) => MediaQuery.of(context).size.height;
  double width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final favIds = favProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Fav Deals', style: AppStyle.bold24black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColor.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('deals').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDeals = snapshot.data!.docs;

          final favDeals = allDeals.where((doc) {
            return favIds.contains(doc.id);
          }).toList();

          if (favDeals.isEmpty) {
            return const Center(child: Text("No Favorites Yet"));
          }

          return ListView.builder(
            itemCount: favDeals.length,
            padding: EdgeInsets.symmetric(
              horizontal: width(context) * 0.04,
              vertical: height(context) * 0.02,
            ),
            itemBuilder: (context, index) {
              final doc = favDeals[index];
              final data = doc.data();
              final id = doc.id;

              return Padding(
                padding: EdgeInsets.only(
                    bottom: height(context) * 0.015),
                child: CardItem(
                  dealData: data,
                  id: id,
                  forceFav: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}