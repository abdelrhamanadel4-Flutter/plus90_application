import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plus90_application/utils/app_color.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isFetchingData = true;
  File? _pickedImage;
  String? _currentPhotoURL;

  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  // ✅ جيب البيانات الحالية من Firestore
  Future<void> _loadCurrentData() async {
    if (_user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        final name = (data['name'] ?? data['displayName'] ?? "")
            .toString()
            .trim();
        _nameController.text = name.isNotEmpty
            ? name
            : (_user.displayName ?? "");

        final photo = (data['photoURL'] ?? "").toString().trim();
        _currentPhotoURL = photo.isNotEmpty ? photo : _user.photoURL;
      } else {
        _nameController.text = _user.displayName ?? "";
        _currentPhotoURL = _user.photoURL;
      }
    } catch (e) {
      _nameController.text = _user.displayName ?? "";
      _currentPhotoURL = _user.photoURL;
    }

    if (mounted) setState(() => _isFetchingData = false);
  }

  // ✅ اختار صورة من الجاليري أو الكاميرا
  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 30, // جودة منخفضة عشان الحجم يكون صغير
      maxWidth: 300,
      maxHeight: 300,
    );
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  // ✅ حوّل الصورة لـ Base64 بدل رفعها على Storage
  Future<String?> _imageToBase64() async {
    if (_pickedImage == null) return null;
    final bytes = await _pickedImage!.readAsBytes();
    return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  }

  // عرض bottom sheet لاختيار المصدر
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Change Profile Photo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF8B1E3F),
                ),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF8B1E3F)),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_currentPhotoURL != null || _pickedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    "Remove Photo",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _pickedImage = null;
                      _currentPhotoURL = null;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ حفظ التغييرات في Firestore + Firebase Auth
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_user == null) return;

    setState(() => _isLoading = true);

    try {
      String? newPhotoURL;

      // ✅ لو اختار صورة جديدة حوّلها لـ Base64
      if (_pickedImage != null) {
        newPhotoURL = await _imageToBase64();
      }

      final String newName = _nameController.text.trim();

      // ✅ حدّث Firebase Auth
      // ملاحظة: updatePhotoURL في Auth بتقبل URL فقط، مش Base64
      // عشان كده هنحفظ الصورة في Firestore بس
      await _user.updateDisplayName(newName);

      // ✅ حدّث Firestore
      final Map<String, dynamic> updateData = {
        'name': newName,
        'displayName': newName,
      };

      if (newPhotoURL != null) {
        // صورة جديدة Base64
        updateData['photoURL'] = newPhotoURL;
      } else if (_currentPhotoURL == null) {
        // المستخدم حذف الصورة
        updateData['photoURL'] = "";
      }
      // لو مفيش تغيير في الصورة → مش بنبعت حاجة (merge هيحافظ على القديمة)

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .set(updateData, SetOptions(merge: true));

      // reload user لتحديث الداتا في Auth
      await _user.reload();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Profile updated successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ✅ Helper: عرض الصورة سواء Base64 أو Network URL أو File
  Widget _buildProfileImage() {
    if (_pickedImage != null) {
      // صورة جديدة من الجهاز
      return Image.file(_pickedImage!, fit: BoxFit.cover);
    }

    if (_currentPhotoURL != null && _currentPhotoURL!.isNotEmpty) {
      if (_currentPhotoURL!.startsWith('data:image')) {
        // ✅ صورة Base64 محفوظة في Firestore
        final base64Str = _currentPhotoURL!.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 55, color: Colors.white),
        );
      } else {
        // صورة Network URL عادية
        return Image.network(
          _currentPhotoURL!,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 55, color: Colors.white),
        );
      }
    }

    // لا توجد صورة
    return const Icon(Icons.person, size: 55, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F1EB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isFetchingData
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // ✅ صورة البروفايل مع زرار التغيير
                      GestureDetector(
                        onTap: _showImageSourceSheet,
                        child: Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                color: Colors.grey.shade300,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(child: _buildProfileImage()),
                            ),
                            // زرار الكاميرا
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B1E3F),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        "Tap to change photo",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      const SizedBox(height: 35),

                      // ✅ حقل الاسم
                      _buildInputField(
                        controller: _nameController,
                        label: "Full Name",
                        icon: Icons.person_outline,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter your name";
                          }
                          if (val.trim().length < 2) {
                            return "Name must be at least 2 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // الإيميل — read only
                      _buildReadOnlyField(
                        value: _user?.email ?? "",
                        label: "Email",
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 40),

                      // ✅ زرار الحفظ
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B1E3F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 3,
                          ),
                          onPressed: _isLoading ? null : _saveChanges,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // زرار الإلغاء
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF8B1E3F)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF8B1E3F),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF8B1E3F)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF8B1E3F), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: Colors.grey.shade400),
      ),
      style: TextStyle(color: Colors.grey.shade500),
    );
  }
}
