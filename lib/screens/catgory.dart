import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom_text_from.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  int selectedindex = 0;

  String searchText = "";
  String selectedCategory = "All";

  final List<String> catgory = [
    "All",
    "Offers",
    "Restaurants & Cafes",
    "Fashion",
    "Beauty & Care",
    "Home Services",
    "Electronics",
    "Events",
    "Automotive",
  ];

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null && args.isNotEmpty) {
        final idx = catgory.indexOf(args);
        if (idx != -1) {
          setState(() {
            selectedindex = idx;
            selectedCategory = args;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          /// APPBAR
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: height(context) * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.orange,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: height(context) * 0.02,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(
                              context,
                              Approutes.HomeScreen,
                            );
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: width(context) * 0.04),
                          Image.asset(
                            AppAssets.catgoryappbar,
                            height: 120,
                            width: 120,
                          ),
                          SizedBox(width: width(context) * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last chance to save,',
                                  style: AppStyle.bold16white,
                                ),
                                Text(
                                  'first step to protect',
                                  style: AppStyle.bold16white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// SEARCH
              Positioned(
                bottom: -25,
                right: width(context) * 0.05,
                left: width(context) * 0.05,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(18),
                  child: CustomTextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: height(context) * 0.02,
                    ),
                    hint: 'Find deals, restaurants, activities...',
                    hintStyle: AppStyle.medium14ramdi,
                    prefixIcon: Image.asset(AppAssets.icon_search),
                    borderColor: AppColor.grayColor,
                    fillColor: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: height(context) * 0.06),

          /// CATEGORIES
          SizedBox(
            height: height(context) * 0.05,
            child: ListView.builder(
              itemCount: catgory.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedindex = index;
                      selectedCategory = catgory[index];
                    });
                  },
                  child: categoryItem(
                    context,
                    title: catgory[index],
                    isSelected: selectedindex == index,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: height(context) * 0.02),

          /// FIREBASE + FILTER
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("deals").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No Deals Found"));
              }

              final allDeals = snapshot.data!.docs;

              final filteredDeals = allDeals.where((doc) {
                final data = doc.data();

                final title = (data['title'] ?? '').toString().toLowerCase();
                final location = (data['location'] ?? '')
                    .toString()
                    .toLowerCase();
                final category = (data['category'] ?? '').toString();

                final matchesCategory = selectedCategory == "All"
                    ? true
                    : category == selectedCategory;

                final matchesSearch = searchText.isEmpty
                    ? true
                    : title.contains(searchText) ||
                          location.contains(searchText);

                // ✅ نفس الـ logic بتاعت Home - بتتعامل مع Timestamp و String
                final expiryDate = _parseDate(data['expiry']);
                final isActive =
                    expiryDate == null || expiryDate.isAfter(DateTime.now());

                // ✅ نفس الـ logic بتاعت Home - stock <= 0 يتشال
                final stock = (data['stock'] as num?)?.toInt() ?? 0;
                final hasStock = stock > 0;

                return matchesCategory && matchesSearch && isActive && hasStock;
              }).toList();

              if (filteredDeals.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("No Deals Found"),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredDeals.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.04,
                ),
                itemBuilder: (context, index) {
                  final data = filteredDeals[index].data();
                  final doc = filteredDeals[index];
                  final id = doc.id;

                  return Padding(
                    padding: EdgeInsets.only(bottom: height(context) * 0.015),
                    child: CardItem(dealData: data, id: id),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget categoryItem(
    BuildContext context, {
    required String title,
    bool isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.only(right: width(context) * 0.03),
      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.07),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.orange : AppColor.grayColor3,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: isSelected ? AppStyle.medium14white : AppStyle.medium14orange,
      ),
    );
  }
}
