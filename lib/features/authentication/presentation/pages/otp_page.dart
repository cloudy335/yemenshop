import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/pages/complete_prfile.dart';

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
    final theme = Theme.of(context);
    final gradient = AppColors.primaryGradient;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                Text(
                  'التحقق من الرمز',
                  style: AppTextStyles.h2
                      .copyWith(color: theme.colorScheme.onBackground),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Description
                Text(
                  'أدخل الرمز المرسل إلى رقم هاتفك',
                  style: AppTextStyles.body1
                      .copyWith(color: theme.colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.lg),

                // OTP Input Fields with gradient outline
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                      padding: const EdgeInsets.all(1), // border thickness
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.normal),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.normal),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) => _handleInput(value, index),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 80),

                // Verify Button with gradient fill
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Collect OTP
                      final otp = _controllers.map((c) => c.text).join();
                      print('Entered OTP: $otp');

                      // Navigate to Complete Profile Page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompleteProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تحقق',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Resend Code
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // Logic to resend the code
                    },
                    child: Text(
                      'إعادة إرسال الرمز؟',
                      style: AppTextStyles.caption
                          .copyWith(color: theme.colorScheme.onBackground),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
