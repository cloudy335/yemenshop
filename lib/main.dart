// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yemenshop/features/authentication/presentation/pages/splash_page.dart';
import 'package:yemenshop/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 1) wire up localization delegates
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 2) supported locales

      // 3) optionally force Arabic for testing

      // routing
      initialRoute: AppRoutes.createLogin,
      onGenerateRoute: AppRoutes.generate,

      // theming
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Rubik',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B3322),
        ),
      ),
    );
  }
}
