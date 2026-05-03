import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7DF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Text(
                    "Support Center",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Color(0xFF8B1E3F),
                    radius: 18,
                    child: Icon(Icons.support_agent, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Center(
                child: Text(
                  "We're here to help anytime",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Ways to Connect",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ), // زودنا الارتفاع
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // يخلي الكلام مرتاح
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12), // كبرنا الأيقونة شوية
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.email_outlined),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 2,
                        ), // مسافة خفيفة من فوق
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Email Support",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17, // كان 15
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Send us a detailed message",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14, // كان 13
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFEAEAEA,
                          ), // لون رمادي فاتح (ممكن تغمقيه)
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Avg reply: 5 min",
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              /// Report Problem Card
              Container(
                height: 240,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    const Text(
                      "Report a Problem",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // كبرنا الخط
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Let us know if something isn't working right.",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),

                    const Spacer(), // 👈 ده أهم حاجة علشان ينزل الزرار تحت
                    /// Button
                    SizedBox(
                      width: double.infinity,
                      height: 35, // 👈 طول ثابت أكبر
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B1E3F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Submit Report",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              const Center(
                child: const Text(
                  "Need more help? Contact our support team.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
