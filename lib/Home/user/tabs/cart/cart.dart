import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:plus90_application/Provider/cart_provider.dart';
import 'package:plus90_application/Home/user/tabs/cart/card_cart.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  double height(BuildContext context) => MediaQuery.of(context).size.height;
  double width(BuildContext context) => MediaQuery.of(context).size.width;

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
              // Upper Header Section
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
                  // Image.asset(
                  //   AppAssets.header_cart,
                  //   height: height(context) * 0.05,
                  // ),
                  Icon(
                    Icons.add_shopping_cart_outlined,
                    color: AppColor.orange,
                  ),
                ],
              ),

              SizedBox(height: height(context) * 0.03),

              // Product List Section - Expanded to handle scrolling
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text(
                          "Your cart is empty",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: height(context) * 0.02,
                            ),
                            // تم تعديل تمرير الـ stock هنا ليأخذ القيمة الحقيقية للمنتج وليس الـ index
                            child: CardCart(id: item.id, stock: item.stock),
                          );
                        },
                      ),
              ),

              // Fixed Bottom Section (Totals and Checkout)
              Column(
                children: [
                  SizedBox(height: height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal", style: AppStyle.medium14ramdi),
                      Text(
                        "\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                        style: AppStyle.semibold14black,
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: AppStyle.bold20black),
                      Text(
                        "\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                        style: AppStyle.bold20orange,
                      ),
                    ],
                  ),
                  SizedBox(height: height(context) * 0.03),

                  // Full-width Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: () {
                        if (cartProvider.items.isEmpty) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Approutes.orderconfirmed,
                          (route) =>
                              false, // ده بيمسح كل الشاشات القديمة من الـ Stack تماماً
                        );
                      },
                      text: 'Checkout',
                      textStyle: AppStyle.semibold20white,
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
