import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plus90_application/Provider/cart_provider.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';

class CardCart extends StatelessWidget {
  final String id;

  const CardCart({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    final item = cartProvider.items[id];

    if (item == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 251, 251),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Image.asset(
                AppAssets.logo,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),

          SizedBox(width: MediaQuery.of(context).size.width * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppStyle.semibold14black),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Text('\$${item.oldPrice}',
                        style: AppStyle.medium14ramdi.copyWith(
                          decoration: TextDecoration.lineThrough,
                        )),
                  ],
                ),

                const SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${item.price}',
                        style: AppStyle.bold20orange),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            cartProvider.decreaseQty(id);
                          },
                          child: Image.asset(
                            AppAssets.Button,
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${item.quantity}',
                            style: AppStyle.bold12orange),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            cartProvider.increaseQty(id);
                          },
                          child: Image.asset(
                            AppAssets.Button2,
                            height: 25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}