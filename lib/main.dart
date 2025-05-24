import 'package:flutter/material.dart';
import 'package:yemenshop/features/authentication/presentation/pages/splash_page.dart';
import 'package:yemenshop/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // start at the Create/Login landing page
      initialRoute: AppRoutes.createLogin,
      onGenerateRoute: AppRoutes.generate,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Ruibik-Regular',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B3322),
        ),
      ),
      home: YemenShopSplashScreen(),
    );
  }
}
