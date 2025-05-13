import 'package:flutter/material.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_account_page.dart'; // Import the create account page
import 'package:yemenshop/features/authentication/presentation/pages/otp_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/reset_password.dart'; // Import the OTP page

class AppRoutes {
  static const String createLogin = '/';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password'; // New route

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
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
      case otp:
        return MaterialPageRoute(
          builder: (_) => OTPPageUI(),
          fullscreenDialog: true,
        );
      case resetPassword: // Handle the forgot password route
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
