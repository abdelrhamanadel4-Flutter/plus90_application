import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/screens/myorder/myorder.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class Myorders extends StatelessWidget {
  const Myorders({super.key});

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.offwhite,
          title: Text('My Orders', style: AppStyle.bold24black),
          leading: Row(
            children: [
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColor.blackColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColor.blackColor,
            labelColor: AppColor.blackColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Pending"),
              Tab(text: "Confirmed"),
              Tab(text: "Rejected"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OrdersList(statusFilter: null),
            _OrdersList(statusFilter: "pending"),
            _OrdersList(statusFilter: "confirmed"),
            _OrdersList(statusFilter: "rejected"),
          ],
        ),
      ),
    );
  }
}

class _OrdersList extends StatefulWidget {
  final String? statusFilter;

  const _OrdersList({this.statusFilter});

  @override
  State<_OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<_OrdersList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  height(context) => MediaQuery.of(context).size.height;
  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final uid = FirebaseAuth.instance.currentUser?.uid;

    Query query = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: uid);

    if (widget.statusFilter != null) {
      query = query.where('status', isEqualTo: widget.statusFilter);
    }

    query = query.orderBy('createdAt', descending: true);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width(context) * 0.04,
        vertical: height(context) * 0.02,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.statusFilter == null
                        ? "No orders yet"
                        : "No ${widget.statusFilter} orders",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final id = orders[index].id;

              return Padding(
                padding: EdgeInsets.only(bottom: height(context) * 0.015),
                child: OrderCard(orderData: data, orderId: id),
              );
            },
          );
        },
      ),
    );
  }
}
