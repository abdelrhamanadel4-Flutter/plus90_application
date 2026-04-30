import 'package:flutter/material.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  String selectedCategory = "Food";

  final categories = ["Food", "Fashion", "Services", "Electronics"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      // AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Add Items",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Image
            const Text(
              "Photos For Post",
              style: TextStyle(
                color: const Color(0xFF8B1E3F),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E5E2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Text("Tap to upload images")),
            ),

            // Category
            const SizedBox(height: 20),
            const Text(
              "CATEGORY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B1E3F),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;

                return ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF8B1E3F),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF8B1E3F),
                  showCheckmark: false, //بتشيل علامة الصح لما تختار
                  backgroundColor: Colors.grey.shade200,

                  onSelected: (val) {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 15),
            // Title
            const Text(
              "TITLE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B1E3F),
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                hintText: "e.g., 50% Off Sushi Platter",
                filled: true,
                fillColor: const Color(0xFFEFEFEF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Description
            const Text(
              "DESCRIPTION",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B1E3F),
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Describe the deal details...",
                filled: true,
                fillColor: const Color(0xFFEFEFEF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Expiry
            const Text(
              "Expiry Information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B1E3F),
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              "Expiry Date",
              style: TextStyle(color: const Color(0xFF8B1E3F)),
            ),
            const SizedBox(height: 10),

            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan Expiry Date"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1E3F),
                    foregroundColor: Colors.white,

                    // 👇 ده اللي هيخليه أطول
                    padding: const EdgeInsets.symmetric(vertical: 24),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Expiry Date",
              style: TextStyle(color: Color(0xFF8B1E3F)),
            ),

            const SizedBox(height: 10),

            SizedBox(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),

                  contentPadding: const EdgeInsets.symmetric(
                    vertical:
                        18, // Increased vertical padding for a taller input field
                    horizontal: 15,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Location
            const Text(
              "LOCATION",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B1E3F),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Select store location",
                  prefixIcon: const Icon(Icons.location_on),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical:
                        18, // Increased vertical padding for a taller input field
                    horizontal: 15,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Publish Button
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1E3F),
                    foregroundColor: Colors.white,

                    // 👇 يخليه أطول شوية زي Expiry
                    padding: const EdgeInsets.symmetric(vertical: 22),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Publish Deal"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
