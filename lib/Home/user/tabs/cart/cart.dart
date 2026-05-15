import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plus90_application/Provider/cart_provider.dart';
import 'package:plus90_application/Home/user/tabs/cart/card_cart.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  double height(context) => MediaQuery.of(context).size.height;
  double width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items.values.toList();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(context) * 0.05,
            vertical: height(context) * 0.02,
          ),
          child: Column(
            children: [
              // الجزء العلوي (الهيدر)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                    onPressed: () =>
                        Navigator.pushNamed(context, Approutes.HomeScreen),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Cart", style: AppStyle.bold20orange),
                      Text(
                        "${items.length} items in your cart",
                        style: AppStyle.medium11ramdi,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(
                    AppAssets.header_cart,
                    height: height(context) * 0.05,
                  ),
                ],
              ),

              SizedBox(height: height(context) * 0.03),

              // قائمة المنتجات - Expanded عشان تاخد المساحة اللي في النص بس وتعمل Scroll
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: height(context) * 0.02),
                      child: CardCart(id: item.id),
                    );
                  },
                ),
              ),

              // الجزء الثابت تحت
              Column(
                children: [
                  SizedBox(height: height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal", style: AppStyle.medium14ramdi),
                      Text("\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                          style: AppStyle.semibold14black),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: AppStyle.bold20black),
                      Text("\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                          style: AppStyle.bold20orange),
                    ],
                  ),
                  SizedBox(height: height(context) * 0.03),
                  
                  // تعديل العرض هنا ليكون بكامل عرض الشاشة
                  SizedBox(
                    width: double.infinity, 
                    child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Approutes.orderconfirmed);
                      },
                      text: 'Checkout',
                      textStyle: AppStyle.semibold20white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}