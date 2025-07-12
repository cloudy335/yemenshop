import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yemenshop/features/authentication/presentation/pages/splash_page.dart';
import 'package:yemenshop/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent background
    statusBarIconBrightness: Brightness.dark, // dark icons for visibility
    statusBarBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.createLogin,
      onGenerateRoute: AppRoutes.generate,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Rubik',
      ),
      home: const YemenShopSplashScreen(),
    );
  }
}
