import 'package:flutter/material.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/login_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_account_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/otp_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/otp_reset_password.dart';
import 'package:yemenshop/features/authentication/presentation/pages/reset_password.dart';

class AppRoutes {
  static const String createLogin = '/';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String otpRegistration = '/otp-page'; // For registration OTP
  static const String otpReset = '/otp-reset'; // For reset OTP
  static const String resetPassword = '/reset-password';

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
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
