// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk SystemChrome
import 'screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBiaOeNB9g77ZSzCSNLK2-lTjCycuRlUK0",
        appId: "1:475941342310:android:856f6c937dc0c7bf60b1a7",
        messagingSenderId: "475941342310",
        projectId: "modul-5-e2bb6",
        storageBucket: "modul-5-e2bb6.appspot.com",
      ),
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna biru seperti di contoh gambar
        fontFamily: 'Inter', // Menggunakan font Inter (pastikan sudah ditambahkan jika perlu)
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      home: const MapScreen(),
    );
  }
}
