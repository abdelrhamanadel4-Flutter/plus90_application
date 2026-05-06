import 'package:flutter/material.dart';
import 'package:plus90_application/screens/IncomingOrder.dart';
import 'package:plus90_application/screens/AddItem.dart';
import 'package:plus90_application/screens/MyItems.dart';

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
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

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
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            /// 🟪 TABS (ثابتة)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xFF8B1E3F)),
              ),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Color(0xFF8B1E3F)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Color(0xFF8B1E3F),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
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
