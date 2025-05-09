// lib/features/authentication/presentation/pages/login_page.dart

import 'package:flutter/material.dart';

class LoginPageUI extends StatelessWidget {
  const LoginPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8D7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),

              // Logo
              Image.asset(
                'assets/images/Logo (4).png',
                width: 120,
                height: 120,
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF331A0B),
                ),
              ),

              const SizedBox(height: 32),

              // Phone field (text and label aligned right)
              // Phone field (text and label aligned right)
              TextField(
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  // ← align label to the right
                  labelText: 'رقم الهاتف',
                  labelStyle: const TextStyle(
                    fontFamily: 'Rubik',
                    color: Color(0xFF331A0B),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

// Password field (text and label aligned right)
              TextField(
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.center,
                obscureText: true,
                decoration: InputDecoration(
                  // ← align label to the right
                  labelText: 'كلمة المرور',
                  labelStyle: const TextStyle(
                    fontFamily: 'Rubik',
                    color: Color(0xFF331A0B),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30)),
                  child: const Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: Color(0xFF331A0B),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF331A0B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
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

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
