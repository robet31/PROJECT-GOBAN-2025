import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyoba_modul_5/screens/category/mobil.dart';
import 'package:nyoba_modul_5/screens/category/motor.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:nyoba_modul_5/screens/home/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyoba_modul_5/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _userName = "User"; // Default value
  String? _userImageUrl;

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
      final data = doc.data()!;
      setState(() {
        _userName = data['name'] ?? 'User';
        _userImageUrl = data['imageUrl'];
      });
    }
  }
  
  final List<Widget> _pages = [
    HomePage(),
    const Center(child: Text("Chat atau Tambal-ban", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Notifikasi", style: TextStyle(fontSize: 24))),
    const ProfileScreen(),
  ];

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 3 ? "Profile Pengguna" : "Go-Ban", // Berubah sesuai tab
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF141E46),
          ),
        ),
        backgroundColor: const Color(0xFF8DECB4),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        actions: _selectedIndex == 3
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => logout(context),
                ),
              ]
            : null,
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 // Hanya tampilkan di beranda
          ? FloatingActionButton(
              onPressed: () {
                // Tambahkan fungsi untuk FAB di beranda
              },
              backgroundColor: const Color(0xFF41B06E),
              child: const Icon(Icons.local_car_wash, color: Colors.white), // Ganti ikon
            )
          : null,
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home),
            title: Text(
              'Beranda',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            activeColor: const Color(0xFF41B06E), // Changed from selectedColor
            inactiveColor: Colors.grey,          // Changed from unselectedColor
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.chat_bubble_outline_outlined),
            title: Text(
              'Chat',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            activeColor: const Color(0xFF41B06E), // Changed from selectedColor
            inactiveColor: Colors.grey,          // Changed from unselectedColor
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.notifications_on_rounded),
            title: Text(
              'Notif',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            activeColor: const Color(0xFF41B06E), // Changed from selectedColor
            inactiveColor: Colors.grey,          // Changed from unselectedColor
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person),
            title: Text(
              'Profil',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            activeColor: const Color(0xFF41B06E), // Changed from selectedColor
            inactiveColor: Colors.grey,          // Changed from unselectedColor
          ),
        ],
        animationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 300),
        iconSize: 24,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data user dari state parent
    final state = context.findAncestorStateOfType<_HomeScreenState>();
    final userName = state?._userName ?? "User";
    final userImageUrl = state?._userImageUrl;

    final user = FirebaseAuth.instance.currentUser;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8DECB4), Color(0xFF41B06E)],
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: userImageUrl != null
                        ? NetworkImage(userImageUrl)
                        : const AssetImage('assets/default_avatar.png') 
                            as ImageProvider,
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $userName", // Gunakan nama dari Firestore
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Mau cari tambal ban terdekat ?",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari tambal ban disekitarmu...",
                  hintStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF41B06E)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // // Categories Section
            // Text(
            //   "Kategori",
            //   style: GoogleFonts.poppins(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: const Color(0xFF141E46),
            //   ),
            // ),
            // const SizedBox(height: 16),
            
            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: 4,
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 16,
            //     mainAxisSpacing: 16,
            //     childAspectRatio: 1.2,
            //   ),
            //   itemBuilder: (context, index) {
            //     List<String> categories = ['Motor', 'Mobil', 'Truck', 'Sepeda'];
            //     List<String> images = [
            //       'assets/icon/motor.png',
            //       'assets/icon/mobil.png',
            //       'assets/icon/truck.png',
            //       'assets/icon/bicycle.png',
            //     ];
            //     List<Color> colors = [
            //       const Color(0xFFFF9EAA),
            //       const Color(0xFF91C8E4),
            //       const Color(0xFFFFD966),
            //       const Color(0xFF8DECB4),
            //     ];

            //     return InkWell(
            //       onTap: () {
            //         if (index == 0) {
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => const MotorPage()));
            //         } else if (index == 1) {
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => const MobilPage()));
            //         }
            //       },
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: colors[index],
            //           borderRadius: BorderRadius.circular(16),
            //           boxShadow: [
            //             BoxShadow(
            //               color: const Color(0x1A000000),
            //               blurRadius: 6,
            //               offset: const Offset(0, 3),
            //             ),
            //           ],
            //         ),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Container(
            //               height: 70,
            //               width: 70,
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage(images[index]),
            //                   fit: BoxFit.contain,
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 12),
            //             Text(
            //               categories[index],
            //               style: GoogleFonts.poppins(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w600,
            //                 color: const Color(0xFF141E46),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(height: 24),
            
            // Recommendations Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rekomendasi",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF141E46),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lihat Semua",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF41B06E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Recommendation Card
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/image/tambal_ban.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tambal Ban Pak Mukhlis",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF41B06E),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    "4.8",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white70, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              "4.2 km | Jl. Sudirman No. 123",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}