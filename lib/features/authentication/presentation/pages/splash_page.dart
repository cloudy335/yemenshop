/// lib/features/splash/presentation/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/pages/introduction.dart';

class YemenShopSplashScreen extends StatefulWidget {
  const YemenShopSplashScreen({Key? key}) : super(key: key);

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
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
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
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSpacing.xl * 4, // 32*4 = 128
                  height: AppSpacing.xl * 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    child: Image.asset(
                      'assets/images/Logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'المتجر اليمني',
                  style: AppTextStyles.h2.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
