import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app_color.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _timeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _getTitle(String type) {
    switch (type) {
      case 'new_order':
        return 'New Order';
      case 'order_approved':
        return 'Order Approved';
      case 'order_rejected':
        return 'Order Rejected';
      default:
        return 'Notification';
    }
  }

  String _getMessage(Map<String, dynamic> data) {
    final type = data['type'] ?? '';
    switch (type) {
      case 'new_order':
        return '${data['buyerName'] ?? 'Someone'} placed a new order with ${data['itemsCount'] ?? 1} item(s).';
      case 'order_approved':
        return 'Your order from ${data['storeName'] ?? 'the store'} has been approved!';
      case 'order_rejected':
        return 'Your order from ${data['storeName'] ?? 'the store'} was rejected.';
      default:
        return data['message'] ?? '';
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'new_order':
        return Icons.shopping_bag_outlined;
      case 'order_approved':
        return Icons.check_circle_outline;
      case 'order_rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'new_order':
        return const Color(0xFF8B1E3F);
      case 'order_approved':
        return Colors.green;
      case 'order_rejected':
        return Colors.red;
      default:
        return const Color(0xFF8B1E3F);
    }
  }

  Future<void> _markAllAsRead(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final unread = await firestore
        .collection('notifications')
        .where('toUserId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = firestore.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColor.offwhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColor.offwhite,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColor.orange,
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColor.orange,
                    ),
                  ),
                  if (user != null)
                    TextButton(
                      onPressed: () => _markAllAsRead(user.uid),
                      child: const Text(
                        "Mark all\nread",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8B1E3F),
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: user == null
                    ? const Center(child: Text("Please Login"))
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('notifications')
                            .where('toUserId', isEqualTo: user.uid)
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF8B1E3F),
                              ),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_off_outlined,
                                    size: 60,
                                    color: AppColor.orange,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "No notifications yet",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }

                          final docs = snapshot.data!.docs;

                          return ListView.separated(
                            itemCount: docs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              final type = data['type'] ?? '';
                              final isRead = data['isRead'] ?? true;
                              final color = _getColor(type);

                              return GestureDetector(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('notifications')
                                      .doc(docs[index].id)
                                      .update({'isRead': true});
                                },
                                child: _NotificationCard(
                                  data: data,
                                  type: type,
                                  isRead: isRead,
                                  color: color,
                                  icon: _getIcon(type),
                                  title: _getTitle(type),
                                  message: _getMessage(data),
                                  timeAgo: _timeAgo(
                                    data['createdAt'] as Timestamp?,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String type;
  final bool isRead;
  final Color color;
  final IconData icon;
  final String title;
  final String message;
  final String timeAgo;

  const _NotificationCard({
    required this.data,
    required this.type,
    required this.isRead,
    required this.color,
    required this.icon,
    required this.title,
    required this.message,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final orderId = data['orderId'] as String? ?? '';
    final shortOrderId = orderId.length >= 8
        ? '#${orderId.substring(0, 8).toUpperCase()}'
        : orderId.isNotEmpty
        ? '#$orderId'
        : '';

    final rejectionReason = data['rejectionReason'] as String?;
    final items = data['items'] as List<dynamic>?;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead ? Colors.transparent : color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: isRead
                                      ? FontWeight.w500
                                      : FontWeight.bold,
                                  fontSize: 14,
                                  color: isRead ? Colors.black87 : Colors.black,
                                ),
                              ),
                              Text(
                                timeAgo,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            message,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!isRead) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                if (shortOrderId.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.receipt_outlined,
                          size: 13,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          shortOrderId,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (type == 'order_rejected' && rejectionReason != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 13,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          rejectionReason,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (type == 'order_rejected' &&
                    items != null &&
                    items.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rejected items",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...items.map((item) {
                          final itemData = item as Map<String, dynamic>;
                          final subtotal =
                              (itemData['subtotal'] as num?)?.toDouble() ?? 0.0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 5,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${itemData['title'] ?? ''} x${itemData['quantity']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '\$${subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Left colored border for unread
        if (!isRead)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
