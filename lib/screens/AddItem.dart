import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plus90_application/Auth/ChooseLocationScreen.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItem> {
  String selectedCategory = "Food";

  final categories = ["Food", "Fashion", "Services", "Electronics"];

  final ImagePicker _picker = ImagePicker();
  TextEditingController locationController = TextEditingController();

  List<XFile> images = [];

  /// 📍 LOCATION DATA
  double? selectedLat;
  double? selectedLng;

  Future<void> pickImages() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final List<XFile> picked = await _picker.pickMultiImage();

      if (picked.isNotEmpty) {
        setState(() {
          images = picked;
        });
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permission denied")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Photos For Post",
              style: TextStyle(
                color: Color(0xFF8B1E3F),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            /// 📸 IMAGES
            GestureDetector(
              onTap: pickImages,
              child: Container(
                height: 140,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5E2),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: images.isEmpty
                    ? const Center(child: Text("Tap to upload images"))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,

                        itemCount: images.length,

                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                File(images[index].path),

                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📝 TITLE
            const Text(
              "TITLE",
              style: TextStyle(
                color: Color(0xFF8B1E3F),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                hintText: "e.g., 50% Off Sushi Platter",

                filled: true,

                fillColor: const Color(0xFFEFEFEF),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 📄 DESCRIPTION
            const Text(
              "DESCRIPTION",
              style: TextStyle(
                fontWeight: FontWeight.bold,

                color: Color(0xFF8B1E3F),
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
                  borderRadius: BorderRadius.circular(8),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🏷️ CATEGORY
            const Text(
              "CATEGORY",
              style: TextStyle(
                fontWeight: FontWeight.bold,

                color: Color(0xFF8B1E3F),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;

                return ChoiceChip(
                  label: Text(
                    cat,

                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF8B1E3F),
                    ),
                  ),

                  selected: isSelected,

                  selectedColor: const Color(0xFF8B1E3F),

                  backgroundColor: Colors.grey.shade200,

                  showCheckmark: false,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),

                  onSelected: (val) {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// ⏰ EXPIRY
            const Text(
              "EXPIRY INFORMATION",
              style: TextStyle(
                color: Color(0xFF8B1E3F),

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,

                height: 60,

                child: ElevatedButton.icon(
                  onPressed: () {},

                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),

                  label: const Text(
                    "Scan Expiry Date",

                    style: TextStyle(color: Colors.white),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1E3F),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Expiry Time",
              style: TextStyle(color: Color(0xFF8B1E3F)),
            ),

            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                filled: true,

                fillColor: const Color(0xFFEFEFEF),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 📍 LOCATION
            /// LOCATION
            const Text(
              "LOCATION",
              style: TextStyle(
                color: Color(0xFF8B1E3F),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: locationController,
              readOnly: true,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseLocationScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    locationController.text = result["address"];
                  });
                }
              },

              decoration: InputDecoration(
                hintText: "Select store location",
                prefixIcon: const Icon(Icons.location_on),
                filled: true,
                fillColor: const Color(0xFFEFEFEF),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🚀 PUBLISH
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,

                height: 60,

                child: ElevatedButton(
                  onPressed: () {
                    print(selectedLat);

                    print(selectedLng);

                    print(locationController.text);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1E3F),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    "Publish Deal",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 16,

                      fontWeight: FontWeight.w600,
                    ),
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
