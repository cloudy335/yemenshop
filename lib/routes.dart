import 'package:flutter/material.dart';
// ... باقي الاستيرادات السابقة
import 'package:yemenshop/features/authentication/presentation/pages/LocationPickerPage.dart';
import 'package:yemenshop/features/authentication/presentation/pages/cart_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_account_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/home_screen_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/otp_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/otp_reset_password.dart';
import 'package:yemenshop/features/authentication/presentation/pages/reset_password.dart';
import 'package:yemenshop/features/authentication/presentation/pages/splash_page.dart'; // أضف هذا لمسار شاشة الخريطة

class AppRoutes {
  // Define all your route constants here
  static const String splash = '/splash';
  static const String introduction = '/introduction';
  static const String createLogin = '/';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String otpRegistration = '/otp-page';
  static const String otpReset = '/otp-reset';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String map = '/map'; // <--- أضفت هذا

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
      case otpRegistration:
        return MaterialPageRoute(
          builder: (_) => OTPPageUI(),
          fullscreenDialog: true,
        );
      case otpReset:
        return MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(),
          fullscreenDialog: true,
        );
      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => YemenShopHomeScreen(),
        );
      case cart:
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
      case map: // <-- شاشة الخريطة
        return MaterialPageRoute(
          builder: (_) =>
              const LocationPickerPage(), // غيرها إلى اسم صفحة الخريطة عندك إذا اختلف
        );
      default:
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
