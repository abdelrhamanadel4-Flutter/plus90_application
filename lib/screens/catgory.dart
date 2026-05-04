import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  int selectedindex = 0;

  List<String> catgory = ['All', 'Fashoin', 'Services', 'Electronics', 'Food'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          /// appbar section
          Stack(
            clipBehavior: Clip.none,

            children: [
              Container(
                height: height(context) * 0.25,

                width: double.infinity,

                decoration: BoxDecoration(
                  color: AppColor.orange,

                  borderRadius: BorderRadius.only(
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
                          child: Icon(
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
                              mainAxisAlignment: MainAxisAlignment.center,

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Last chance to save,',
                                  style: AppStyle.bold16white,
                                ),

                                Text(
                                  '           first step to protect',
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

              /// search
              Positioned(
                bottom: -25,

                right: width(context) * 0.05,

                left: width(context) * 0.05,

                child: Material(
                  elevation: 8,

                  borderRadius: BorderRadius.circular(18),

                  child: CustomTextFormField(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: height(context) * 0.02,
                    ),

                    hint: 'Find deals, restaurants, activities...',

                    hintStyle: AppStyle.medium14ramdi,

                    prefixIcon: Image.asset(
                      AppAssets.icon_search,
                      height: height(context) * 0.000,
                    ),

                    borderColor: AppColor.grayColor,

                    fillColor: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: height(context) * 0.06),

          /// categories
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

          /// cards
          ListView.builder(
            itemCount: 5,

            shrinkWrap: true,

            physics: NeverScrollableScrollPhysics(),

            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),

            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: height(context) * 0.015),

                child: CardItem(),
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
