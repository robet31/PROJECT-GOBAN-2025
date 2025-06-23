import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:nyoba_modul_5/screens/auth/edit_profile_screen.dart';
// import 'package:nyoba_modul_5/screens/auth/change_password_screen.dart';
import 'package:nyoba_modul_5/screens/home/change_password_screen.dart';
import 'package:nyoba_modul_5/screens/home/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        _userData = doc.data()!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tidak ada app bar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 40),
            // const Text(
            //   "Profile Pengguna",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     fontFamily: 'Poppins',
            //   ),
            // ),
            const SizedBox(height: 30),
            
            // Profile photo
            CircleAvatar(
              radius: 90,
              backgroundImage: _userData?['imageUrl'] != null
                  ? NetworkImage(_userData!['imageUrl'])
                  : null,
              child: _userData?['imageUrl'] == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 20),
            
            // User info
            Text(
              _userData?['name'] ?? 'Nama Pengguna',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              _userData?['email'] ?? 'email@example.com',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 40),
            
            // Menu options
            _buildMenuOption(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.notifications,
              title: 'Notification',
              onTap: () {},
            ),
            _buildMenuOption(
              icon: Icons.location_on,
              title: 'Shipping Address',
              onTap: () {},
            ),
            _buildMenuOption(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF41B06E)),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}