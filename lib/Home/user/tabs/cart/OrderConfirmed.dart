import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plus90_application/Provider/cart_provider.dart';
import 'package:plus90_application/utils/Approutes.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';

class OrderConfirmed extends StatefulWidget {
  const OrderConfirmed({super.key});

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  bool _isLoading = true;
  String _orderId = '';
  double _totalAmount = 0.0;
  String _errorMsg = '';
  bool _orderPlacedSuccessfully = false;

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    _orderPlacedSuccessfully = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      _totalAmount = cartProvider.totalPrice;
      // نأخذ نسخة عميقة من العناصر حتى لا تتأثر بمسح السلة
      final cartItems = cartProvider.items.values.toList();

      await _placeOrder(cartItems);
    });
  }

  Future<void> _placeOrder(List<dynamic> items) async {
    if (_orderPlacedSuccessfully) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMsg = '';
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _errorMsg = 'User not logged in.';
          _isLoading = false;
        });
      }
      return;
    }

    if (items.isEmpty) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final orderRef = firestore.collection('orders').doc();
      final orderId = orderRef.id;
      final now = FieldValue.serverTimestamp();

      final Map<String, List<Map<String, dynamic>>> itemsByStore = {};
      double totalAmount = 0;

      for (final item in items) {
        itemsByStore.putIfAbsent(item.storeId, () => []);
        itemsByStore[item.storeId]!.add({
          'dealId': item.id,
          'title': item.title,
          'price': item.price,
          'oldPrice': item.oldPrice,
          'image': item.image,
          'quantity': item.quantity,
          'subtotal': item.price * item.quantity,
        });
        totalAmount += item.price * item.quantity;
      }

      final batch = firestore.batch();

      batch.set(orderRef, {
        'orderId': orderId,
        'buyerId': user.uid,
        'buyerEmail': user.email ?? '',
        'buyerName': user.displayName ?? '',
        'totalAmount': totalAmount,
        'status': 'pending',
        'createdAt': now,
        'storeIds': itemsByStore.keys.toList(),
        'items': items
            .map((i) => {
                  'dealId': i.id,
                  'title': i.title,
                  'price': i.price,
                  'quantity': i.quantity,
                  'storeId': i.storeId,
                  'image': i.image,
                })
            .toList(),
      });

      for (final entry in itemsByStore.entries) {
        final storeId = entry.key;
        final storeItems = entry.value;

        final storeTotalAmount = storeItems.fold<double>(
          0,
          (sum, item) => sum + (item['subtotal'] as double),
        );

        final subOrderRef = orderRef.collection('subOrders').doc(storeId);
        batch.set(subOrderRef, {
          'storeId': storeId,
          'orderId': orderId,
          'buyerId': user.uid,
          'buyerName': user.displayName ?? '',
          'buyerEmail': user.email ?? '',
          'items': storeItems,
          'totalAmount': storeTotalAmount,
          'status': 'pending',
          'createdAt': now,
        });

        final notifRef = firestore.collection('notifications').doc();
        batch.set(notifRef, {
          'toUserId': storeId,
          'type': 'new_order',
          'orderId': orderId,
          'subOrderId': storeId,
          'buyerName': user.displayName ?? '',
          'buyerEmail': user.email ?? '',
          'totalAmount': storeTotalAmount,
          'itemsCount': storeItems.length,
          'isRead': false,
          'createdAt': now,
        });
      }

      // تنفيذ الـ Batch في Firebase أولاً
      await batch.commit();

      if (mounted) {
        // تحديث حالة الشاشة وتثبيت البيانات أولاً قبل أي عملية مسح
        setState(() {
          _orderId = orderId.substring(0, 8).toUpperCase();
          _orderPlacedSuccessfully = true;
          _isLoading = false;
        });

        // مسح السلة نتركه في النهاية تماماً بعد استقرار الواجهة
        Provider.of<CartProvider>(context, listen: false).clearCart();
      }
    } catch (e) {
      // طباعة الخطأ الحقيقي في الـ Console إذا حدثت مشكلة في الفايربيس
      debugPrint("🚨 Firebase Error: $e");
      if (mounted) {
        setState(() {
          _errorMsg = 'Something went wrong: $e';
          _isLoading = false;
        });
      }
    }
  }

  double get _h => MediaQuery.of(context).size.height;
  double get _w => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF861E43)),
        ),
      );
    }

    if (_errorMsg.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(_errorMsg, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF861E43),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, Approutes.HomeScreen),
                  child: const Text(
                    'Back To Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _w * 0.04,
            vertical: _h * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              Image.asset(AppAssets.orderconfirmed,
                  height: 250, width: 300),

              Center(
                child: Text(
                  'Order Confirmed!',
                  style: AppStyle.bold20orange,
                ),
              ),

              SizedBox(height: _h * 0.01),

              Text(
                'Please wait for the product owner\'s confirmation.',
                textAlign: TextAlign.center,
                style: AppStyle.medium14ramdi,
              ),

              SizedBox(height: _h * 0.02),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _w * 0.02,
                  vertical: _h * 0.02,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: _w * 0.04,
                          vertical: _h * 0.01,
                        ),
                        child: Row(
                          children: [
                            Text('Order ID',
                                style: AppStyle.medium14ramdi),
                            const Spacer(),
                            Text('#$_orderId',
                                style: AppStyle.semibold14orange),
                          ],
                        ),
                      ),

                      const Divider(),

                      buildInfoItem(
                        context,
                        icon: Icons.storefront_outlined,
                        title: 'Total Paid',
                        subtitle:
                            '\$${_totalAmount.toStringAsFixed(2)}',
                      ),

                      SizedBox(height: _h * 0.02),

                      buildInfoItem(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        title: 'Payment Method',
                        subtitle: 'Cash on Delivery',
                      ),

                      SizedBox(height: _h * 0.02),

                      buildInfoItem(
                        context,
                        icon: Icons.calendar_month_outlined,
                        title: 'Order Status',
                        subtitle: 'Waiting for Approval',
                      ),

                      SizedBox(height: _h * 0.02),
                    ],
                  ),
                ),
              ),

              SizedBox(height: _h * 0.03),

              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, Approutes.HomeScreen);
                },
                text: 'Back To Home',
                textStyle: AppStyle.semibold20white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _w * 0.04, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Text(title, style: AppStyle.medium14ramdi),
          const Spacer(),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}