import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Ensure this file properly initializes Firebase
import 'login_screen.dart';   // Import your LoginScreen
import 'register_screen.dart'; // Import your RegisterScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await initializeFirebase();                // Initialize Firebase
  runApp(const MyApp());                     // Run the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StaySpot',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set primary color
        fontFamily: 'Poppins',      // Ensure 'Poppins' font is in pubspec.yaml
      ),
      // You can choose which route you want to start on.
      // If you want the LoginScreen to be the first screen, set initialRoute to '/login'.
      initialRoute: '/login',
      routes: {
        // Named route for Login
        '/login': (context) => const LoginScreen(),
        // Named route for Register
        '/register': (context) => const RegisterScreen(),
        // If you have a homepage, define it here as well, for example:
        // '/home': (context) => const HomePage(),
      },
    );
  }
}
