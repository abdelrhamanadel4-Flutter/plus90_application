import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class CardIncomingOrder extends StatelessWidget {
  final Map<String, dynamic> data;
  final String orderId;
 
  final String subOrderId;
  final String buyerId;
  final List<dynamic> items;
  final double totalAmount;
  final String storeName;
  final Timestamp? createdAt;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const CardIncomingOrder({
    super.key,
    required this.data,
  
    required this.orderId,
    required this.subOrderId,
    required this.buyerId,
    required this.items,
    required this.totalAmount,
    required this.storeName,
    required this.createdAt,
    required this.onApprove,
    required this.onReject,
  });

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  // ── Time ago ─────────────────────────────────────────
  String _timeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final buyerName = data['buyerName'] as String? ?? '';
    final buyerEmail = data['buyerEmail'] as String? ?? '';

    final shortId = orderId.length >= 8
        ? '#${orderId.substring(0, 8).toUpperCase()}'
        : '#$orderId';

    // ── أول item في الطلب لعرض صورته وسعره ──────────────
    final firstItem = items.isNotEmpty ? items[0] as Map<String, dynamic> : null;
    final firstTitle = firstItem?['title'] as String? ?? 'Order';
    final firstImageUrl = firstItem?['imageUrl'] as String?;
    final firstOriginalPrice = (firstItem?['originalPrice'] as num?)?.toDouble();
    final firstDiscountedPrice = (firstItem?['discountedPrice'] as num?)?.toDouble();
    final firstQuantity = firstItem?['quantity'] as int? ?? 1;
    final extraItemsCount = items.length > 1 ? items.length - 1 : 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width(context) * 0.03,
        vertical: height(context) * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColor.grayColor3,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Section ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left: Image + Order ID + Buyer ───────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة الـ item الأول
                  Container(
                    height: height(context) * 0.13,
                    width: width(context) * 0.28,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: firstImageUrl != null && firstImageUrl.isNotEmpty
                        ? Image.network(
                            firstImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColor.orange,
                              size: 36,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColor.orange,
                            size: 36,
                          ),
                  ),

                  SizedBox(height: height(context) * 0.01),

                  SizedBox(
                    width: width(context) * 0.28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shortId, style: AppStyle.semibold14black),
                        SizedBox(height: height(context) * 0.004),
                        Text(
                          'Name: $buyerName',
                          style: AppStyle.semibold14black,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (buyerEmail.isNotEmpty) ...[
                          SizedBox(height: height(context) * 0.003),
                          Text(
                            buyerEmail,
                            style: AppStyle.semibold14black.copyWith(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(width: width(context) * 0.04),

              // ── Right: Details ───────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Time ago
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            firstTitle,
                            style: AppStyle.bold18orange,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.access_time_outlined,
                          color: AppColor.orange,
                          size: width(context) * 0.04,
                        ),
                        SizedBox(width: width(context) * 0.01),
                        Text(
                          _timeAgo(createdAt),
                          style: AppStyle.bold12orange,
                        ),
                      ],
                    ),

                    SizedBox(height: height(context) * 0.01),

                    // السعر بعد الخصم
                    if (firstDiscountedPrice != null)
                      Text(
                        '\$${firstDiscountedPrice.toStringAsFixed(2)}',
                        style: AppStyle.bold20orange,
                      ),

                    // السعر الأصلي مشطوب
                    if (firstOriginalPrice != null) ...[
                      SizedBox(height: height(context) * 0.004),
                      Text(
                        '\$${firstOriginalPrice.toStringAsFixed(2)}',
                        style: AppStyle.medium14ramdi.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],

                    // لو السعرين مش موجودين نعرض التوتال
                    if (firstDiscountedPrice == null && firstOriginalPrice == null)
                      Text(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        style: AppStyle.bold20orange,
                      ),

                    SizedBox(height: height(context) * 0.015),

                    // Quantity + Phone
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity: x$firstQuantity',
                          style: AppStyle.semibold14black,
                        ),
                        SizedBox(height: height(context) * 0.004),
                        if (data['buyerPhone'] != null)
                          Text(
                            'Phone: ${data['buyerPhone']}',
                            style: AppStyle.semibold14black,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),

                    // لو في أكتر من item نعرض badge
                    if (extraItemsCount > 0) ...[
                      SizedBox(height: height(context) * 0.008),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColor.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColor.orange.withOpacity(0.3)),
                        ),
                        child: Text(
                          '+$extraItemsCount more item${extraItemsCount > 1 ? 's' : ''}',
                          style: AppStyle.bold12orange.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: height(context) * 0.015),

          // ── Divider + Total ──────────────────────────
          const Divider(color: Colors.white24, thickness: 1),
          SizedBox(height: height(context) * 0.008),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Order', style: AppStyle.semibold14black),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: AppStyle.bold18orange,
              ),
            ],
          ),

          SizedBox(height: height(context) * 0.015),

          // ── Buttons ──────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Accept
              Expanded(
                child: GestureDetector(
                  onTap: onApprove,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height(context) * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7ED36E),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text('Accept', style: AppStyle.bold16white),
                  ),
                ),
              ),

              SizedBox(width: width(context) * 0.04),

              // Reject
              Expanded(
                child: GestureDetector(
                  onTap: onReject,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height(context) * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD90F16),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text('Reject', style: AppStyle.bold16white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}