import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';
import 'package:plus90_application/screens/AddItem.dart';

class CardMyItem extends StatefulWidget {
  final String title;
  final String location;
  final String initialPrice;
  final String discountedPrice;
  final String? imageUrl;
  final DateTime? expiryDate;
  final String id;
  final String? description;
  final String? stock;
  final String category;

  const CardMyItem({
    super.key,
    required this.title,
    required this.location,
    required this.initialPrice,
    required this.discountedPrice,
    this.imageUrl,
    this.expiryDate,
    required this.id,
    this.description,
    this.stock,
    required this.category,
  });

  @override
  State<CardMyItem> createState() => _CardMyItemState();
}

class _CardMyItemState extends State<CardMyItem> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    // يحدث الـ timer كل ثانية
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    if (widget.expiryDate == null) return;
    final now = DateTime.now();
    final diff = widget.expiryDate!.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get isActive =>
      widget.expiryDate != null && widget.expiryDate!.isAfter(DateTime.now());

  String get timerText {
    if (widget.expiryDate == null) return '--:--:--';
    if (!isActive) return '00:00:00';

    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width(context) * 0.03,
        vertical: height(context) * 0.01,
      ),
      decoration: BoxDecoration(
        color: AppColor.grayColor3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// image
          Container(
            height: height(context) * 0.12,
            width: width(context) * 0.26,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(18),
              image: widget.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(widget.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage(AppAssets.donut),
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          SizedBox(width: width(context) * 0.035),

          /// details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title + edit
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppStyle.bold18orange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddItem(
                              isEdit: true,
                              dealId: widget.id,
                              title: widget.title,
                              description: widget.description,
                              location: widget.location,
                              initialPrice: widget.initialPrice,
                              discountedPrice: widget.discountedPrice,
                              stock: widget.stock,
                              category: widget.category,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        AppAssets.edit,
                        color: AppColor.orange,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.005),

                /// location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColor.grayColor2,
                      size: width(context) * 0.045,
                    ),
                    SizedBox(width: width(context) * 0.01),
                    Expanded(
                      child: Text(
                        widget.location,
                        style: AppStyle.medium11ramdi,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.008),

                /// price + status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '\$${widget.discountedPrice}',
                      style: AppStyle.bold20orange,
                    ),
                    const Spacer(),

                    /// ✅ Status ديناميكي
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.05,
                        vertical: height(context) * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF7ED36E) // أخضر = Active
                            : const Color(0xFFD70000), // أحمر = Expired
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Expired',
                        style: AppStyle.bold12white.copyWith(
                          fontSize: width(context) * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height(context) * 0.003),

                /// old price
                Text(
                  '\$${widget.initialPrice}',
                  style: AppStyle.medium14ramdi.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

                SizedBox(height: height(context) * 0.01),

                /// timer
                Row(
                  children: [
                    Text(
                      isActive ? 'Ends In' : 'Expired',
                      style: TextStyle(
                        color: const Color(0xffD70000),
                        fontWeight: FontWeight.bold,
                        fontSize: width(context) * 0.045,
                      ),
                    ),
                    SizedBox(width: width(context) * 0.02),
                    Icon(
                      Icons.access_time_outlined,
                      color: const Color(0xffD70000),
                      size: width(context) * 0.05,
                    ),
                    SizedBox(width: width(context) * 0.02),
                    Text(
                      timerText,
                      style: TextStyle(
                        color: const Color(0xffD70000),
                        fontWeight: FontWeight.bold,
                        fontSize: width(context) * 0.045,
                      ),
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
