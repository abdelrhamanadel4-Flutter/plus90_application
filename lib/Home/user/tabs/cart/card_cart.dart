import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:plus90_application/Provider/cart_provider.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_style.dart';

class CardCart extends StatelessWidget {
  final String id;
  final int stock;

  const CardCart({super.key, required this.id, required this.stock});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final item = cartProvider.items[id];

    if (item == null) return const SizedBox.shrink();

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart, // Swipe from right to left to delete
      onDismissed: (direction) {
        cartProvider.removeItem(id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColor.orange,
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
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (item.image.isNotEmpty)
                  ? Image.network(
                      item.image,
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
                  // Title and Quick Delete Button
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

                  // Old Price (Strikethrough)
                  Text(
                    '\$${item.oldPrice}',
                    style: AppStyle.medium14ramdi.copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                    ),
                  ),

                  // Current Price and Quantity Controllers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${item.price}', style: AppStyle.bold20orange),
                      
                      // Quantity Control Panel
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Decrease Button
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
                            
                            // Quantity Text
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item.quantity}',
                                style: AppStyle.bold12orange.copyWith(fontSize: 14),
                              ),
                            ),
                            
                            // Increase Button with Stock Validation & SnackBar Action
                            GestureDetector(
                              onTap: () {
                                final String? errorMessage = cartProvider.increaseQty(id, stock);
                                if (errorMessage != null) {
                                  ScaffoldMessenger.of(context).clearSnackBars(); // Clears existing snackbars instantly
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        errorMessage,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                     
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
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

  // Confirmation dialog before removal
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
              provider.removeItem(id);
              Navigator.of(ctx).pop();
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}