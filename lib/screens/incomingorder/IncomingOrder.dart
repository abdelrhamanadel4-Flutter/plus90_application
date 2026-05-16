import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/screens/incomingorder/card.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class IncomingOrder extends StatelessWidget {
  const IncomingOrder({super.key});

  double height(context) => MediaQuery.of(context).size.height;
  double width(context) => MediaQuery.of(context).size.width;

  static const List<String> _rejectionReasons = [
    'Out of stock',
    'Not enough quantity',
    'Location is too far',
    'Deal has expired',
    'Unable to fulfill at this time',
  ];

  // ── Approve ──────────────────────────────────────────
  Future<void> _approveOrder(
    BuildContext context,
    String orderId,
    String subOrderId,
    String buyerId,
    List<dynamic> items,
    String storeName,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    try {
      final subOrderRef = firestore
          .collection('orders')
          .doc(orderId)
          .collection('subOrders')
          .doc(subOrderId);
      batch.update(subOrderRef, {'status': 'approved'});

      for (final item in items) {
        final dealId = item['dealId'] as String?;
        final quantity = item['quantity'] as int? ?? 1;
        if (dealId != null) {
          final dealRef = firestore.collection('deals').doc(dealId);
          batch.update(dealRef, {'stock': FieldValue.increment(-quantity)});
        }
      }

      final notifRef = firestore.collection('notifications').doc();
      batch.set(notifRef, {
        'toUserId': buyerId,
        'type': 'order_approved',
        'orderId': orderId,
        'storeName': storeName,
        'message':
            'Your order has been approved! We will contact you soon for delivery.',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order approved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ── Rejection Dialog ─────────────────────────────────
  Future<void> _showRejectionDialog(
    BuildContext context,
    String orderId,
    String subOrderId,
    String buyerId,
    List<dynamic> items,
    String storeName,
  ) async {
    String? selectedReason;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          title: const Text(
            'Reason for Rejection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF861E43),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please select a reason to send to the buyer:',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ..._rejectionReasons.map((reason) {
                return GestureDetector(
                  onTap: () => setStateDialog(() => selectedReason = reason),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedReason == reason
                          ? const Color(0xFFFBEAF0)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedReason == reason
                            ? const Color(0xFF861E43)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedReason == reason
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: const Color(0xFF861E43),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reason,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: selectedReason == reason
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF861E43),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: selectedReason == null
                  ? null
                  : () async {
                      Navigator.pop(ctx);
                      await _rejectOrder(
                        context,
                        orderId,
                        subOrderId,
                        buyerId,
                        selectedReason!,
                        items,
                        storeName,
                      );
                    },
              child: const Text('Send',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reject ───────────────────────────────────────────
  Future<void> _rejectOrder(
    BuildContext context,
    String orderId,
    String subOrderId,
    String buyerId,
    String reason,
    List<dynamic> items,
    String storeName,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    try {
      final subOrderRef = firestore
          .collection('orders')
          .doc(orderId)
          .collection('subOrders')
          .doc(subOrderId);
      batch.update(subOrderRef, {
        'status': 'rejected',
        'rejectionReason': reason,
      });

      final notifRef = firestore.collection('notifications').doc();
      batch.set(notifRef, {
        'toUserId': buyerId,
        'type': 'order_rejected',
        'orderId': orderId,
        'storeName': storeName,
        'rejectionReason': reason,
        'items': items,
        'message': 'Your order was rejected. Reason: $reason',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order rejected and buyer notified.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please Login')),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('subOrders')
          .where('storeId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        final pendingCount = snapshot.data?.docs.length ?? 0;

        return Scaffold(
          backgroundColor: AppColor.offwhite,
          appBar: AppBar(
            backgroundColor: AppColor.offwhite,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Text('Incoming Orders', style: AppStyle.bold18orange),
                SizedBox(width: width(context) * 0.02),
                if (pendingCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColor.orange.withOpacity(0.3)),
                    ),
                    child: Text(
                      '$pendingCount pending',
                      style: AppStyle.bold12orange,
                    ),
                  ),
              ],
            ),
          ),
          body: Builder(
            builder: (context) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.orange),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_outlined,
                          size: 60, color: AppColor.orange),
                      SizedBox(height: height(context) * 0.015),
                      const Text(
                        'No incoming orders',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.04,
                  vertical: height(context) * 0.01,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  final orderId = data['orderId'] as String? ?? '';
                  final subOrderId = doc.id;
                  final buyerId = data['buyerId'] as String? ?? '';
                  final totalAmount =
                      (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
                  final items = data['items'] as List<dynamic>? ?? [];
                  final createdAt = data['createdAt'] as Timestamp?;
                  final storeName =
                      data['storeName'] as String? ?? 'Our Store';

                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: height(context) * 0.015),
                    child: CardIncomingOrder(
                      data: data,
                      orderId: orderId,
                      subOrderId: subOrderId,
                      buyerId: buyerId,
                      items: items,
                      totalAmount: totalAmount,
                      storeName: storeName,
                      createdAt: createdAt,
                      onApprove: () => _approveOrder(
                        context,
                        orderId,
                        subOrderId,
                        buyerId,
                        items,
                        storeName,
                      ),
                      onReject: () => _showRejectionDialog(
                        context,
                        orderId,
                        subOrderId,
                        buyerId,
                        items,
                        storeName,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}