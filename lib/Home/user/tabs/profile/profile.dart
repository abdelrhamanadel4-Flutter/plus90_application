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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              if (user != null)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String displayName = user.displayName?.isNotEmpty == true
                        ? user.displayName!
                        : "User";
                    String? photoURL = user.photoURL;
                    String totalSaved = "\$0.00";
                    String activeOrders = "0 Deals";

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      final firestoreName =
                          (data['name'] ?? data['displayName'] ?? "")
                              .toString()
                              .trim();
                      if (firestoreName.isNotEmpty) {
                        displayName = firestoreName;
                      }

                      final firestorePhoto = (data['photoURL'] ?? "")
                          .toString()
                          .trim();
                      if (firestorePhoto.isNotEmpty) {
                        photoURL = firestorePhoto;
                      }

                      final saved = data['totalSaved'];
                      if (saved != null) {
                        totalSaved =
                            "\$${(saved as num).toDouble().toStringAsFixed(2)}";
                      }

                      final orders = data['activeOrders'];
                      if (orders != null) {
                        activeOrders = "$orders Deals";
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    color: Colors.grey,
                                  ),
                                  child: ClipOval(
                                    child: _buildProfileImage(photoURL),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email ?? "",
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
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
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBE7E7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Row(
                          children: [
                            _statCard(
                              Icons.attach_money,
                              isStore ? "Total Sales" : "Total Saved",
                              totalSaved,
                            ),
                            const SizedBox(width: 10),
                            _statCard(
                              Icons.shopping_bag,
                              isStore ? "My Products" : "Active Orders",
                              activeOrders,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 30),

              Text(
                isStore ? "Store Activity" : "My Activity",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              if (!isStore)
                _menuItem(context, Icons.receipt, "My Orders", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Myorders()),
                  );
                }),

              if (!isStore)
                _menuItem(context, Icons.bookmark, "Fav Deals", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favdeals()),
                  );
                }),

              _menuItem(context, Icons.headset_mic, "Support Center", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupportScreen(),
                  ),
                );
              }),

              _menuItem(context, Icons.location_on, "Location", () {
                if (user == null) return;
                Navigator.pushNamed(
                  context,
                  Approutes.ChooseLocationScreen,
                  arguments: user.uid,
                );
              }),

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
                          const Icon(
                            Icons.logout,
                            size: 50,
                            color: AppColor.orange,
                          ),
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
                                backgroundColor: const Color(0xFF8B1E3F),
                              ),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Auth(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                "Log out",
                                style: TextStyle(color: Colors.white),
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.logout, color: AppColor.orange),
                      SizedBox(width: 10),
                      Text("Log Out", style: TextStyle(color: AppColor.orange)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? photoURL) {
    if (photoURL == null || photoURL.isEmpty) {
      return const Center(
        child: Icon(Icons.person, size: 40, color: Colors.white),
      );
    }

    if (photoURL.startsWith('data:image')) {
      try {
        final base64Str = photoURL.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 40, color: Colors.white),
        );
      } catch (_) {
        return const Icon(Icons.person, size: 40, color: Colors.white);
      }
    }

    return Image.network(
      photoURL,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, size: 40, color: Colors.white),
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              Icon(icon, color: const Color(0xFF8B1E3F)),
              const SizedBox(width: 15),
              Expanded(child: Text(title)),
              const Icon(Icons.arrow_forward_ios, size: 16),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}
