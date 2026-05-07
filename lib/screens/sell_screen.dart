import 'package:flutter/material.dart';
import 'package:plus90_application/screens/IncomingOrder.dart';
import 'package:plus90_application/screens/AddItem.dart';
import 'package:plus90_application/screens/MyItems.dart';
import 'package:plus90_application/screens/SellNotification.dart';
import 'package:plus90_application/screens/SellNotification.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [IncomingOrder(), AddItem(), MyItems()];
  final List<String> tabs = ["Incoming Orders", "Add Items", "My Items"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 HEADER (ثابت)
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
                  const SizedBox(height: 10),
                  const SizedBox(width: 16),
                  const CircleAvatar(radius: 22),
                  const SizedBox(width: 10),

                  /// 📝 USER INFO
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Shrouk Mohamed"),
                      Text("Owner", style: TextStyle(color: Colors.grey)),
                    ],
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

            /// 🟪 TABS (ثابتة)
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
                            ), // 👈 المربع البنفسجي أصغر
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? const Color(0xFF8B1E3F)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                fontSize: 12, // 👈 الخط أكبر
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

            /// 📄 CONTENT (اللي بيتغير)
            Expanded(child: pages[selectedIndex]),
          ],
        ),
      ),
    );
  }
}
