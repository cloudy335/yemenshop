import 'package:flutter/material.dart';
import 'splashScreen.dart';

void main() => runApp(const YemenShopApp());

class YemenShopApp extends StatelessWidget {
  const YemenShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const YemenShopSplashScreen(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4B3322),
        brightness: Brightness.dark,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الرئيسية',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3D281B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          'مرحبا بكم في المتجر اليمني',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF2E1E12),
    );
  }
}
