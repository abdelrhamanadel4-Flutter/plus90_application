import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plus90_application/screens/incomingorder/IncomingOrder.dart';
import 'package:plus90_application/screens/AddItem.dart';
import 'package:plus90_application/screens/myitem/MyItems.dart';
import 'package:plus90_application/screens/SellNotification.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  int selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  final List<Widget> pages = const [IncomingOrder(), AddItem(), MyItems()];
  final List<String> tabs = ["Incoming Orders", "Add Items", "My Items"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  /// 🔙 BACK BUTTON
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 18,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// 👤 USER IMAGE
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            );
                          }
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final photoURL = (data['photoURL'] ?? "")
                              .toString()
                              .trim();
                          return _buildProfileImage(photoURL);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  /// 📝 USER INFO
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("User"),
                            Text("Owner", style: TextStyle(color: Colors.grey)),
                          ],
                        );
                      }
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final displayName =
                          (data['name'] ?? data['displayName'] ?? "User")
                              .toString();
                      final role = (data['role'] ?? "Owner").toString();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(displayName),
                          Text(
                            role,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),

                  const Spacer(),

                  /// 🔔 NOTIFICATION
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Sellnotification(),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.notifications_none,
                          color: Color(0xFF8B1E3F),
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🟪 TABS
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF8B1E3F)),
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 25,
                            ),
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? const Color(0xFF8B1E3F)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: selectedIndex == index
                                    ? Colors.white
                                    : const Color(0xFF8B1E3F),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 15),

            /// 📄 CONTENT
            Expanded(child: pages[selectedIndex]),
          ],
        ),
      ),
    );
  }
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
