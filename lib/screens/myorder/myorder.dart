import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String orderId;

  const OrderCard({super.key, required this.orderData, required this.orderId});

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'delivered':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final status = orderData['status'] ?? 'pending';
    final totalAmount = orderData['totalAmount'] ?? 0;
    final createdAt = orderData['createdAt'] as Timestamp?;
    final items = orderData['items'] as List<dynamic>? ?? [];

    return Container(
      decoration: BoxDecoration(
        color: AppColor.grayColor3,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Status + Date header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (createdAt != null)
                Text(
                  _formatDate(createdAt.toDate()),
                  style: AppStyle.medium14ramdi,
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor(status)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Items
          ...items.map((item) {
            final itemMap = item as Map<String, dynamic>;
            final title = itemMap['title'] ?? 'Item';
            final price = itemMap['price'] ?? 0;
            final quantity = itemMap['quantity'] ?? 1;
            final image = itemMap['image']?.toString() ?? '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  /// Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppAssets.donut,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 70,
                                height: 70,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF8B1E3F),
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            AppAssets.donut,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                  ),

                  const SizedBox(width: 12),

                  /// Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppStyle.bold18orange,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quantity: $quantity',
                          style: AppStyle.medium14ramdi,
                        ),
                        const SizedBox(height: 4),
                        Text('\$$price', style: AppStyle.bold20orange),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 16),

          /// Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: AppStyle.semibold14orange),
              Text('\$$totalAmount', style: AppStyle.bold20orange),
            ],
          ),
        ],
      ),
    );
  }
}
