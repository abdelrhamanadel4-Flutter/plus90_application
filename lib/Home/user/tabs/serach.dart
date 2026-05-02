import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom_text_from.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});
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
            SizedBox(height: height(context) * 0.3),
            Text(
              'No products found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: height(context) * 0.01),
            Text(
              'Try adjusting your search or filter to find what you are looking for.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
