// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yemenshop/routes.dart';
import 'package:yemenshop/core/theme/design_system.dart' as design;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildThemeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Rubik',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4B3322),
        primary: design.AppColors.primary,
        secondary: design.AppColors.secondary,
        surface: design.AppColors.surface,
        background: design.AppColors.background,
        error: design.AppColors.error,
        onPrimary: design.AppColors.textOnPrimary,
        onSurface: design.AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: design.AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: design.AppColors.surface,
        elevation: design.AppElevation.low,
        iconTheme: IconThemeData(color: design.AppColors.textPrimary),
        titleTextStyle: design.AppTextStyles.h2,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: design.AppElevation.medium,
        color: design.AppColors.surface,
        margin: const EdgeInsets.symmetric(
          horizontal: design.AppSpacing.md,
          vertical: design.AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.AppRadius.normal),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: design.AppColors.textPrimary,
        contentTextStyle: design.AppTextStyles.body1.copyWith(
          color: design.AppColors.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.AppRadius.small),
        ),
        actionTextColor: design.AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generate,
      theme: _buildThemeData(),
      locale: const Locale('ar', ''),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
    );
  }
}
