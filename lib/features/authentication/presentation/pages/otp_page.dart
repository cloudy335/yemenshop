import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class OTPPageUI extends StatefulWidget {
  const OTPPageUI({Key? key}) : super(key: key);

  @override
  State<OTPPageUI> createState() => _OTPPageUIState();
}

class _OTPPageUIState extends State<OTPPageUI> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty && value.length == 1) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus(); // Last field, remove focus
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr, // Change to LTR
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl * 2.5),

                // Logo
                Image.asset(
                  'assets/images/Logo.png',
                  width: 140,
                  height: 140,
                ),

                const SizedBox(height: AppSpacing.md),

                // Title
                const Text(
                  'التحقق من الرمز',
                  style: AppTextStyles.h2,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Description
                const Text(
                  'أدخل الرمز المرسل إلى رقم هاتفك',
                  style: AppTextStyles.body1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.lg),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.normal),
                            borderSide: const BorderSide(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        onChanged: (value) => _handleInput(value, index),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 80),

                // Resend Code

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Collect OTP
                      final otp = _controllers.map((c) => c.text).join();
                      print('Entered OTP: $otp');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                    ),
                    child: const Text(
                      'تحقق',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center, // Center the button
                  child: TextButton(
                    onPressed: () {
                      // Logic to resend the code
                    },
                    child: const Text(
                      'إعادة إرسال الرمز؟',
                      style: AppTextStyles.caption,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
