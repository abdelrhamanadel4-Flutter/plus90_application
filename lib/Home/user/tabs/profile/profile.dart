import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plus90_application/Auth/auth.dart';
import 'package:plus90_application/Home/user/tabs/profile/edit_profile.dart';
import 'package:plus90_application/screens/Favdeals.dart';
import 'package:plus90_application/screens/myorders.dart';
import 'package:plus90_application/screens/support_screen.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app_color.dart';

class ProfileTab extends StatelessWidget {
  final bool isStore;

  const ProfileTab({super.key, this.isStore = false});

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  bool _isActive(dynamic expiry) {
    DateTime? expiryDate = _parseDate(expiry);
    if (expiryDate == null) return false;
    return expiryDate.isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please Login")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          String displayName =
              user.displayName?.isNotEmpty == true ? user.displayName! : "User";
          String? photoURL = user.photoURL;
          String totalSaved = "\$0.00";

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            final firestoreName =
                (data['name'] ?? data['displayName'] ?? "").toString().trim();
            if (firestoreName.isNotEmpty) displayName = firestoreName;

            final firestorePhoto = (data['photoURL'] ?? "").toString().trim();
            if (firestorePhoto.isNotEmpty) photoURL = firestorePhoto;

            final saved = data['totalSaved'];
            if (saved != null) {
              totalSaved =
                  "\$${(saved as num).toDouble().toStringAsFixed(2)}";
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Gradient Header ─────────────────────────
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColor.orange,
                            Color(0xFFB5354A),
                            Color.fromARGB(255, 168, 162, 153),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 56, 20, 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Edit button
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Avatar
                          Stack(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColor.offwhite,
                                    width: 3,
                                  ),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: ClipOval(
                                  child: _buildProfileImage(photoURL),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColor.offwhite,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            displayName,
                            style: const TextStyle(
                              color: AppColor.offwhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email ?? "",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ── Stats Cards pulled up ────────────────────
                Transform.translate(
                  offset: const Offset(0, -36),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Total Sales card
                        Expanded(
                          child: _statCard(
                            icon: Icons.attach_money_rounded,
                            iconBg: const Color(0xFFFBEAF0),
                            iconColor: AppColor.orange,
                            label: isStore ? "Total Sales" : "Total Saved",
                            value: totalSaved,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // My Products / Active Orders card (live from Firestore)
                        Expanded(
                          child: isStore
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('deals')
                                      .where('storeId', isEqualTo: user.uid)
                                      .snapshots(),
                                  builder: (context, dealsSnapshot) {
                                    int activeCount = 0;
                                    if (dealsSnapshot.hasData) {
                                      for (var doc
                                          in dealsSnapshot.data!.docs) {
                                        final data = doc.data()
                                            as Map<String, dynamic>;
                                        if (_isActive(data['expiry'])) {
                                          activeCount++;
                                        }
                                      }
                                    }
                                    return _statCard(
                                      icon: Icons.shopping_bag_outlined,
                                      iconBg: const Color(0xFFEAF3DE),
                                      iconColor: const Color(0xFF3B6D11),
                                      label: "My Products",
                                      value: "$activeCount Active",
                                    );
                                  },
                                )
                              : StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('orders')
                                      .where('userId', isEqualTo: user.uid)
                                      .snapshots(),
                                  builder: (context, ordersSnapshot) {
                                    int ordersCount =
                                        ordersSnapshot.hasData
                                            ? ordersSnapshot.data!.docs.length
                                            : 0;
                                    return _statCard(
                                      icon: Icons.shopping_bag_outlined,
                                      iconBg: const Color(0xFFEAF3DE),
                                      iconColor: const Color(0xFF3B6D11),
                                      label: "Active Orders",
                                      value: "$ordersCount Deals",
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Menu Section ─────────────────────────────
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 4),
                          child: Text(
                            isStore ? "STORE ACTIVITY" : "MY ACTIVITY",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.blackColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),

                        // Menu items container
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              if (!isStore)
                                _menuItem(
                                  icon: Icons.receipt_long_outlined,
                                  title: "My Orders",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Myorders()),
                                  ),
                                  showDivider: true,
                                ),
                              if (!isStore)
                                _menuItem(
                                  icon: Icons.bookmark_outline,
                                  title: "Fav Deals",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Favdeals()),
                                  ),
                                  showDivider: true,
                                ),
                              _menuItem(
                                icon: Icons.headset_mic_outlined,
                                title: "Support Center",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SupportScreen(),
                                  ),
                                ),
                                showDivider: true,
                              ),
                              _menuItem(
                                icon: Icons.location_on_outlined,
                                title: "Location",
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Approutes.ChooseLocationScreen,
                                    arguments: user.uid,
                                  );
                                },
                                showDivider: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ── Logout ───────────────────────────
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                contentPadding: const EdgeInsets.all(25),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.logout,
                                        size: 50, color: AppColor.orange),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Log out",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Are you sure you want to log out?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 25),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF8B1E3F),
                                        ),
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const Auth(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        child: const Text(
                                          "Log out",
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Cancel"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFEBEB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.logout,
                                      color: Color(0xFFD70000),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Text(
                                    "Log Out",
                                    style: TextStyle(
                                      color: Color(0xFFD70000),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEAF0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF861E43), size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 66, endIndent: 16),
      ],
    );
  }

  Widget _buildProfileImage(String? photoURL) {
    if (photoURL == null || photoURL.isEmpty) {
      return const Center(
        child: Icon(Icons.person, size: 36, color: Colors.white),
      );
    }

    if (photoURL.startsWith('data:image')) {
      try {
        final base64Str = photoURL.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 36, color: Colors.white),
        );
      } catch (_) {
        return const Icon(Icons.person, size: 36, color: Colors.white);
      }
    }

    return Image.network(
      photoURL,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, size: 36, color: Colors.white),
    );
  }
}