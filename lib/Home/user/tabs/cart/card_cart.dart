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
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final item = cartProvider.items[id];

    if (item == null) return const SizedBox.shrink();

    // إضافة الـ Dismissible للسحب للحذف
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart, // السحب من اليمين للشمال
      onDismissed: (direction) {
        cartProvider.removeItem(id); // تأكدي إن الميثود دي موجودة في الـ Provider
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (item.image != null && item.image!.isNotEmpty)
                  ? Image.network(
                      item.image!,
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.1,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppAssets.logo,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    )
                  : Image.asset(
                      AppAssets.logo,
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.1,
                    ),
            ),

            SizedBox(width: MediaQuery.of(context).size.width * 0.04),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم وزرار الحذف السريع
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppStyle.semibold14black,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(context, cartProvider, id),
                        child: Icon(Icons.close, color: Colors.grey.shade400, size: 20),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '\$${item.oldPrice}',
                    style: AppStyle.medium14ramdi.copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${item.price}', style: AppStyle.bold20orange),
                      
                      // التحكم في الكمية
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (item.quantity > 1) {
                                  cartProvider.decreaseQty(id);
                                } else {
                                  _showDeleteDialog(context, cartProvider, id);
                                }
                              },
                              child: Image.asset(AppAssets.Button, height: 28),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('${item.quantity}',
                                  style: AppStyle.bold12orange.copyWith(fontSize: 14)),
                            ),
                            GestureDetector(
                              onTap: () => cartProvider.increaseQty(id),
                              child: Image.asset(AppAssets.Button2, height: 28),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ميثود إظهار رسالة التأكيد عند الحذف
  void _showDeleteDialog(BuildContext context, CartProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Item"),
        content: const Text("Are you sure you want to remove this item from cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              provider.removeItem(id); // تأكدي إن removeItem موجودة في البروفايدر
              Navigator.of(ctx).pop();
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}