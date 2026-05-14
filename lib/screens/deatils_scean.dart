import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/Provider/cart_provider.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/utils/custom-elveted-buttom.dart';
import 'package:plus90_application/Home/user/tabs/cart/cart.dart';
import 'package:plus90_application/utils/Dialog_utils.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> dealData;

  const DetailsScreen({
    super.key,
    required this.dealData,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  bool isfav = false;
  bool isStore = false;
  bool isLoadingRole = true;

  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    _startTimer();
  }

  /// جيب الـ role من Firestore
  Future<void> _fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final role = doc.data()?['role'] ?? 'user';
      setState(() {
        isStore = role == 'store';
        isLoadingRole = false;
      });
    }
  }

  /// countdown timer
  void _startTimer() {
    final expiry = widget.dealData['expiry'];
    if (expiry == null) return;

    final expiryDate = DateTime.tryParse(expiry);
    if (expiryDate == null) return;

    _updateRemaining(expiryDate);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining(expiryDate);
    });
  }

  void _updateRemaining(DateTime expiryDate) {
    final diff = expiryDate.difference(DateTime.now());
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get isActive {
    final expiry = widget.dealData['expiry'];
    if (expiry == null) return false;
    final expiryDate = DateTime.tryParse(expiry);
    return expiryDate != null && expiryDate.isAfter(DateTime.now());
  }

  String get timerText {
    if (!isActive) return '00:00:00';
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// حساب نسبة الخصم
  String get discountPercent {
    final initial =
        double.tryParse(widget.dealData['initialPrice'] ?? '0') ?? 0;
    final discounted =
        double.tryParse(widget.dealData['discountedPrice'] ?? '0') ?? 0;
    if (initial == 0) return '';
    final percent = ((initial - discounted) / initial * 100).round();
    return '-$percent%';
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.dealData;
    final imageUrl = (data['images'] as List?)?.isNotEmpty == true
        ? data['images'][0]
        : null;

    return Scaffold(
      backgroundColor: AppColor.offwhite,
      appBar: AppBar(
        backgroundColor: AppColor.offwhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// صورة الديل
            Center(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 280,
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) => Image.asset(
                        AppAssets.donut,
                        height: 280,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Image.asset(
                      AppAssets.donut,
                      height: 280,
                      fit: BoxFit.fill,
                    ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.grayColor3,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// title + fav
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['title'] ?? '',
                                style: AppStyle.bold18orange,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => isfav = !isfav);
                                DialogUtils.showMessage(
                                  context: context,
                                  message: isfav
                                      ? "Added to favorites"
                                      : "Removed from favorites",
                                );
                              },
                              icon: Icon(
                                isfav ? Icons.favorite : Icons.favorite_border,
                                color: AppColor.orange,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// description
                      Text(
                        data['description'] ?? '',
                        style: AppStyle.medium14orange,
                      ),

                      const SizedBox(height: 20),

                      /// timer
                      Row(
                        children: [
                          Text(
                            isActive ? "Ends In " : "Expired",
                            style: const TextStyle(
                              color: Color(0xffD70000),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.timelapse_outlined,
                            color: Color(0xffD70000),
                          ),
                          Text(
                            timerText,
                            style: const TextStyle(
                              color: Color(0xffD70000),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// price + discount badge
                      Row(
                        children: [
                          Text(
                            "${data['discountedPrice'] ?? '0'} EGP",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.orange,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${data['initialPrice'] ?? '0'} EGP",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (discountPercent.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                discountPercent,
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// store info card
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.orange),
                          color: AppColor.offwhite,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      AssetImage(AppAssets.donut),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Shrouk Mohamed",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Owner",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.phone,
                                    color: AppColor.orange,
                                  ),
                                ),
                                const Text("01123673905"),
                              ],
                            ),
                            const Divider(height: 25),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColor.orange,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    data['location'] ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Text(
                                  'View Details',
                                  style: AppStyle.medium14orange,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: AppColor.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// الزرار بيتغير حسب الـ role
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: isLoadingRole
                              ? const Center(child: CircularProgressIndicator())
                              : isStore
                                  /// Store → Edit
                                  ? CustomElevatedButton(
                                      onPressed: () {
                                        // Navigator.push(context, MaterialPageRoute(
                                        //   builder: (_) => EditDealScreen(dealData: widget.dealData),
                                        // ));
                                      },
                                      text: 'Edit Deal',
                                      textStyle: AppStyle.semibold20white,
                                      hasSuffix: true,
                                      iconWidgetSuf: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColor.offwhite,
                                      ),
                                    )
                                  /// User → Add to Cart
                                  : CustomElevatedButton(
                                      onPressed: () {
        final cart = Provider.of<CartProvider>(context, listen: false);

  cart.addItem(
    id: data['id'] ?? '',
    title: data['title'] ?? '',
    price: double.tryParse(data['discountedPrice'].toString()) ?? 0,
    oldPrice: double.tryParse(data['initialPrice'].toString()) ?? 0,
    image: (data['images'] != null && data['images'].isNotEmpty)
        ? data['images'][0]
        : '',
  );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CartTab(),
                                          ),
                                        );
                                      },
                                      text: 'Add to cart',
                                      textStyle: AppStyle.semibold20white,
                                      hasSuffix: true,
                                      iconWidgetSuf: const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: AppColor.offwhite,
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}