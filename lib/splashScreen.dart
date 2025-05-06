import 'dart:async';

import 'package:flutter/material.dart';
import 'introduction.dart';
import 'main.dart'; // لاستخدام HomeScreen

class YemenShopSplashScreen extends StatefulWidget {
  const YemenShopSplashScreen({super.key});

  @override
  State<YemenShopSplashScreen> createState() => _YemenShopSplashScreenState();
}

class _YemenShopSplashScreenState extends State<YemenShopSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupNavigation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  void _setupNavigation() {
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _navigationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _buildAnimatedBackground(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogo(),
                const SizedBox(height: 30),
                _buildAppName(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E1E12),
            Color(0xFF331A0B),
          ],
        ),
      ),
      child: child,
    );
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'assets/images/icon.png', // تأكد من تعديل مسار الصورة
            fit: BoxFit.contain,
            color: Colors.white.withOpacity(0.9),
            colorBlendMode: BlendMode.modulate,
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const Text(
        'المتجر اليمني',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          letterSpacing: 1.2,
          shadows: [
            Shadow(
              blurRadius: 10,
              color: Colors.black12,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
