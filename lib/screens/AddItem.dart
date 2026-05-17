import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plus90_application/Auth/ChooseLocationScreen.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AddItem extends StatefulWidget {
  final bool isEdit;
  final String? dealId;
  final String? title;
  final String? description;
  final String? location;
  final String? initialPrice;
  final String? discountedPrice;
  final String? stock;
  final String? category;
  final List<String>? imageUrls;

  const AddItem({
    super.key,
    this.isEdit = false,
    this.dealId,
    this.title,
    this.location,
    this.initialPrice,
    this.discountedPrice,
    this.description,
    this.stock,
    this.category,
    this.imageUrls,
  });

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

  List<String> existingImageUrls = [];
  List<XFile> images = [];
  double? selectedLat;
  double? selectedLng;
  DateTime? expiryDateTime;
  bool isLoading = false;

  void _loadData() {
    titleController.text = widget.title ?? "";
    descriptionController.text = widget.description ?? "";
    locationController.text = widget.location ?? "";
    intialprice.text = widget.initialPrice ?? "";
    finalprice.text = widget.discountedPrice ?? "";
    stockController.text = widget.stock ?? "";
    selectedCategory = widget.category ?? "Offers";
    existingImageUrls = List<String>.from(widget.imageUrls ?? []);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      _loadData();
    }
  }

  Future<String?> uploadImageToImgBB(XFile imageFile) async {
    const apiKey = "82cb3297b0bedcf14c531ceb81ab661e";

    final uri = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(uri, body: {"image": base64Image});

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json["success"] == true) {
      return json["data"]["url"] as String;
    }
    return null;
  }

  Future<void> pickImages() async {
    final List<XFile> picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => images.addAll(picked));
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
    final isEdit = widget.isEdit;
    final uid = FirebaseAuth.instance.currentUser?.uid;

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

    double initial = double.tryParse(intialprice.text) ?? 0;
    double discounted = double.tryParse(finalprice.text) ?? 0;

    if (discounted > initial) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Discounted price can't be higher than original price"),
        ),
      );
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

    if (expiryDateTime == null && !isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an expiry date")),
      );
      return;
    }

    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    setState(() => isLoading = true);

    List<String> newImageUrls = [];
    for (final img in images) {
      final url = await uploadImageToImgBB(img);
      if (url != null) newImageUrls.add(url);
    }

    final allImageUrls = [...existingImageUrls, ...newImageUrls];

    final data = {
      "uid": uid,
      "storeId": uid,
      "title": titleController.text,
      "description": descriptionController.text,
      "category": selectedCategory,
      "location": locationController.text,
      "lat": selectedLat,
      "lng": selectedLng,
      "images": allImageUrls,
      "createdAt": FieldValue.serverTimestamp(),
      "initialPrice": intialprice.text,
      "discountedPrice": finalprice.text,
      "stock": int.tryParse(stockController.text) ?? 0,
      if (expiryDateTime != null) "expiry": expiryDateTime?.toIso8601String(),
    };

    try {
      if (isEdit == true && widget.dealId != null) {
        await FirebaseFirestore.instance
            .collection("deals")
            .doc(widget.dealId)
            .update(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Deal updated successfully")),
        );
      } else {
        await FirebaseFirestore.instance.collection("deals").add(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Deal published successfully")),
        );
      }

      setState(() {
        images.clear();
        existingImageUrls.clear();
        titleController.clear();
        descriptionController.clear();
        locationController.clear();
        expiryController.clear();
        stockController.clear();
        expiryDateTime = null;
        isLoading = false;
      });

      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    child: (images.isEmpty && existingImageUrls.isEmpty)
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 40,
                                  color: Color(0xFF8B1E3F),
                                ),
                                SizedBox(height: 8),
                                Text("Tap to upload images (optional)"),
                              ],
                            ),
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...existingImageUrls.map(
                                (url) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          url,
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => setState(
                                            () => existingImageUrls.remove(url),
                                          ),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ...images.asMap().entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(entry.value.path),
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => setState(
                                            () => images.removeAt(entry.key),
                                          ),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                      onPressed: isLoading ? null : submitDeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1E3F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.isEdit ? "Update Deal" : "Publish Deal",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF8B1E3F)),
                    SizedBox(height: 16),
                    Text(
                      "Uploading images...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
