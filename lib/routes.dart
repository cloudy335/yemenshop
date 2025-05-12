import 'package:flutter/material.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_account_page.dart'; // Import the create account page
import 'package:yemenshop/features/authentication/presentation/pages/otp_page.dart'; // Import the OTP page

class AppRoutes {
  static const String createLogin = '/';
  static const String login = '/login';
  static const String createAccount =
      '/create-account'; // Add create account route
  static const String otp = '/otp'; // Add OTP route

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
          builder: (_) => const OTPPageUI(), // Link to the OTP page
          fullscreenDialog: true,
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
