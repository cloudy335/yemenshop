import 'package:flutter/material.dart';
// Make sure all these imports are correct and point to your actual page files
import 'package:yemenshop/features/authentication/presentation/pages/create_login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/home_screen_page.dart'; // Make sure this is your actual home screen widget
import 'package:yemenshop/features/authentication/presentation/pages/login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_account_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/otp_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/otp_reset_password.dart';
import 'package:yemenshop/features/authentication/presentation/pages/reset_password.dart';
import 'package:yemenshop/features/authentication/presentation/pages/splash_page.dart'; // Added for splash route

import 'features/authentication/presentation/pages/cart_page.dart'; // Import for IntroductionPage

class AppRoutes {
  // Define all your route constants here
  static const String splash = '/splash'; // Assuming you want a splash screen
  static const String introduction =
      '/introduction'; // Assuming you have an intro screen
  static const String createLogin =
      '/'; // This is your initial route, landing on CreateLoginPageUI
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String otpRegistration = '/otp-page'; // For registration OTP
  static const String otpReset = '/otp-reset'; // For reset OTP
  static const String resetPassword = '/reset-password';
  static const String home = '/home'; // <--- THIS IS THE MISSING LINE!
  static const String cart = '/cart'; // Assuming you have a cart route

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const YemenShopSplashScreen());

      case createLogin:
        return MaterialPageRoute(
          builder: (_) => const CreateLoginPageUI(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPageUI(),
          fullscreenDialog: true,
        );
      case createAccount:
        return MaterialPageRoute(
          builder: (_) => const CreateAccountPageUI(),
          fullscreenDialog: true,
        );
      case otpRegistration: // Registration OTP Page
        return MaterialPageRoute(
          builder: (_) => OTPPageUI(),
          fullscreenDialog: true,
        );
      case otpReset: // Reset Password OTP Page
        return MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(),
          fullscreenDialog: true,
        );
      case resetPassword: // Reset Password Page
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
        );
      case home: // Home Page
        return MaterialPageRoute(
          builder: (_) =>
              YemenShopHomeScreen(), // Ensure this is your actual home screen widget
        );
      case cart: // Cart Page (if you have one)
        return MaterialPageRoute(
          builder: (_) => CartScreenUI(
            items: const [],
            subTotal: 0.0,
            deliveryFee: 0.0,
            discount: 0.0,
            totalCost: 0.0,
            onQuantityChanged: (item, quantity) {},
            onRemoveItem: (item) {},
            onUndoRemove: (item) {},
            onApplyPromoCode: (code) {},
            onCheckout: () {},
          ),
        );
      default:
        // Fallback for unknown routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('خطأ في المسار')),
            body: Center(
              child: Text(
                'المسار ${settings.name} غير موجود!',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
    }
  }
}
