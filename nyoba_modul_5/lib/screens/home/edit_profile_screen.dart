import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:nyoba_modul_5/screens/home/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _profileImage;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _imageUrl = data['imageUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  // Fungsi untuk mengompres gambar dengan error handling
  Future<File?> _compressImage(String path) async {
    try {
      final original = File(path);
      final imageBytes = await original.readAsBytes();

      // Batasi ukuran file maksimal 5MB
      if (imageBytes.length > 5 * 1024 * 1024) {
        if (kDebugMode) {
          print("Image too large, compressing...");
        }
      }

      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Failed to decode image");

      final compressed = img.copyResize(
        image,
        width: 1200,
        maintainAspect: true,
      );

      final tempFile = File('${original.path}_compressed.jpg');
      await tempFile.writeAsBytes(img.encodeJpg(compressed, quality: 85));

      return tempFile;
    } catch (e) {
      if (kDebugMode) {
        print("Compression error: $e");
      }
      return null;
    }
  }

  Future<String> _uploadToCloudinary(File imageFile) async {
    // Ubah return type ke String
    try {
      final compressedImage = await _compressImage(imageFile.path);
      final fileToUpload = compressedImage ?? imageFile;

      final dio = Dio();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          fileToUpload.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'upload_preset': 'tz1jldlq',
      });

      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/duncrb8jk/image/upload',
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Upload gagal: ${response.data?['error']?['message'] ?? 'Unknown error'}",
        );
      }

      return response.data['secure_url'] as String; // Kembalikan string
    } catch (e) {
      if (kDebugMode) {
        print("Upload error: $e");
      }
      rethrow;
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String? imageUrl = _imageUrl;
      if (_profileImage != null) {
        imageUrl = await _uploadToCloudinary(_profileImage!);
      }

      await FirebaseFirestore.instance
          .collection('Profile')
          .doc(user.uid)
          .update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'imageUrl': imageUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context); // Kembali ke halaman profile
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (_imageUrl != null ? NetworkImage(_imageUrl!) : null),
                  child: _profileImage == null && _imageUrl == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}