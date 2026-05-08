import 'package:flutter/material.dart';
import 'package:plus90_application/Home/card_item.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class DeatilsScrean extends StatelessWidget {
  const DeatilsScrean({super.key});

  @override
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.offwhite,
      appBar: AppBar(
        backgroundColor: AppColor.offwhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  AppAssets.donut,
                  fit: BoxFit.contain,
                  height: 280,
                  width: 350,
                ),
              ),
              const SizedBox(height: 8),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.grayColor3,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Unicorn Sprinkles", style: AppStyle.bold18orange),
                      SizedBox(height: 10),
                      Text(
                        "A fluffy fresh cooked donut covered by a creamy strawberry flavour with rainbow sprinkles.",
                        style: AppStyle.medium14orange,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Ends In",
                            style: TextStyle(
                              color: Color(0xffD70000),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('08:15:29', style: AppStyle.bold12orange),
                          SizedBox(height: 10),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "78 EGP",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: AppColor.orange,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "100 EGP",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "-12%",
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(AppAssets.donut),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Shrouk Mohamed",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Owner",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.phone, color: Colors.pink),
                                SizedBox(width: 8),
                                Text("01123673905"),
                              ],
                            ),
                            Container(
                              width: 306,
                              height: 0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColor.orange),
                                color: AppColor.whiteColor,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: AppColor.orange),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Nasr City, Cairo, Egypt\nEl Tayaran St. - Beside City Stars Mall",
                                    style: TextStyle(height: 1.3),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    // final url =
                                    //     "https://www.google.com/maps/search/?api=1&query=Nasr+City+Cairo+Egypt";
                                    // if (await canLaunchUrl(Uri.parse(url))) {
                                    //   await launchUrl(Uri.parse(url),
                                    //       mode: LaunchMode.externalApplication);
                                    // }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "View on map",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.orange,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: AppColor.orange,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomElevatedButton(
                        onPressed: () {},
                        text: 'Add to cart',
                        textStyle: AppStyle.semibold20white,
                      ),
                      SizedBox(height: height(context) * 0.02),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
