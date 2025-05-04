// lib/features/authentication/presentation/pages/login_page.dart

import 'package:flutter/material.dart';

class CreateLoginPageUI extends StatelessWidget {
  const CreateLoginPageUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8D7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 140),

              // Logo
              Image.asset(
                'assets/images/Logo (4).png',
                width: 250,
                height: 250,
              ),

              // Title immediately under the logo
              const Text(
                'المتجر اليمني',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color(0xFF6C2F17),
                ),
              ),
              const SizedBox(height: 170),

              // Description
              const Text(
                'انطلق في رحلة الذوق اليمني مع المتجر اليمني أول تطبيق في السعودية يجمع أفضل وأشهر المنتجات اليمنية الأصيلة مثل العسل الفاخر والبُن المختار ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14.5,
                  color: Color(0xFF6C2F17),
                  height: 1.8, // line-height for multi-line spacing
                  wordSpacing: 1.9,
                ),
              ),

              const Spacer(),

              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: navigate to login form
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C2F17),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: navigate to registration form
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C2F17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
