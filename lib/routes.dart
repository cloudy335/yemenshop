// lib/core/routes.dart

import 'package:flutter/material.dart';
import 'package:yemenshop/features/authentication/presentation/pages/createLogin_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/login_page.dart';

class AppRoutes {
  // landing screen:
  static const String createLogin = '/';
  // actual login form:
  static const String login = '/login';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case createLogin:
        return MaterialPageRoute(builder: (_) => const CreateLoginPageUI());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPageUI());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
