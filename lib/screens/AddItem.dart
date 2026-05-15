import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plus90_application/Auth/ChooseLocationScreen.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItem> {
  String selectedCategory = "Offers";

  final List<String> categories = [
    "Offers",
    "Restaurants & Cafes",
    "Fashion",
    "Beauty & Care",
    "Home Services",
    "Electronics",
    "Events",
    "Automotive",
  ];

  final ImagePicker _picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController intialprice = TextEditingController();
  TextEditingController finalprice = TextEditingController();
  TextEditingController stockController = TextEditingController();

  List<XFile> images = [];
  double? selectedLat;
  double? selectedLng;
  DateTime? expiryDateTime;

  Future<void> pickImages() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final List<XFile> picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) {
        setState(() {
          images = picked;
        });
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permission denied")));
    }
  }

  Future<void> pickExpiryDateTime() async {
    DateTime now = DateTime.now();
    DateTime maxDate = now.add(const Duration(days: 5));

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: maxDate,
      initialDate: now,
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final fullDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      expiryDateTime = fullDateTime;
      expiryController.text = _formatRemainingTime(fullDateTime);
    });
  }

  String _formatRemainingTime(DateTime expiry) {
    final duration = expiry.difference(DateTime.now());
    if (duration.isNegative) return "Expired";
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    return "Expires in: $days Days and $hours Hours";
  }

  Future<void> submitDeal() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a title")));
      return;
    }

    if (intialprice.text.isEmpty || finalprice.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter prices")));
      return;
    }

    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a description")),
      );
      return;
    }

    if (locationController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a location")));
      return;
    }

    if (expiryDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an expiry date")),
      );
      return;
    }

    // ✅ التعديل هنا: التأكد من أن التاريخ المختار لم ينتهِ بعد
    if (expiryDateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The expiry date is already past. Please select a future date."),),);
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("deals").add({
        "uid": uid,
        "storeId": uid,
        "title": titleController.text,
        "description": descriptionController.text,
        "category": selectedCategory,
        "location": locationController.text,
        "lat": selectedLat,
        "lng": selectedLng,
        "images": [],
        "expiry": expiryDateTime?.toIso8601String(),
        "createdAt": FieldValue.serverTimestamp(),
        "initialPrice": intialprice.text,
        "discountedPrice": finalprice.text,
        "stock": int.tryParse(stockController.text) ?? 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deal published successfully")),
      );

      setState(() {
        images.clear();
        titleController.clear();
        descriptionController.clear();
        locationController.clear();
        expiryController.clear();
        stockController.clear();
        expiryDateTime = null;
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.offwhite,
      appBar: AppBar(
        backgroundColor: AppColor.offwhite,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 16),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF8B1E3F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    ? const Center(
                        child: Text("Tap to upload images (optional)"),
                      )
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
            const Text(
              "TITLE",
              style: TextStyle(
                color: Color(0xFF8B1E3F),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "e.g., 50% Off Sushi Platter",
                filled: true,
                fillColor: const Color(0xFFE0E5E2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Prices",
              style: TextStyle(
                color: Color(0xFF8B1E3F),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: intialprice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Original Price",
                      filled: true,
                      fillColor: const Color(0xFFE0E5E2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: finalprice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Discounted Price",
                      filled: true,
                      fillColor: const Color(0xFFE0E5E2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              "AVAILABLE STOCK",
              style: TextStyle(
                color: Color(0xFF8B1E3F),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Quantity (e.g. 10)",
                filled: true,
                fillColor: const Color(0xFFE0E5E2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "DESCRIPTION",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B1E3F),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Describe the deal details...",
                filled: true,
                fillColor: const Color(0xFFE0E5E2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "CATEGORY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B1E3F),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
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
                      onSelected: (_) =>
                          setState(() => selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "EXPIRY TIME",
              style: TextStyle(
                color: Color(0xFF8B1E3F),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: expiryController,
              readOnly: true,
              onTap: pickExpiryDateTime,
              decoration: InputDecoration(
                hintText: "Select expiry date and time",
                filled: true,
                fillColor: const Color(0xFFE0E5E2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                    builder: (context) =>
                        const ChooseLocationScreen(fromAddItem: true),
                  ),
                );
                if (result != null) {
                  setState(() {
                    locationController.text = result["address"];
                    selectedLat = result["lat"];
                    selectedLng = result["lng"];
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Select store location",
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Color(0xFF8B1E3F),
                ),
                filled: true,
                fillColor: const Color(0xFFE0E5E2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 60,
                child: ElevatedButton(
                  onPressed: submitDeal,
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