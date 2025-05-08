import 'dart:async';

import 'package:flutter/material.dart';
import 'introduction.dart'; // لاستخدام OnboardingScreen

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
        backgroundColor: const Color(0xFFF5E8D7),
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
      color: const Color(0xFFF5E8D7), // لون الخلفية الموحد
      child: child,
    );
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(child: Image.asset('assets/images/icon.png')),
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
          color: Color(0xFF3D281B),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
