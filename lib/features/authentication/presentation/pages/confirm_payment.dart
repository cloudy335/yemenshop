// lib/features/authentication/presentation/pages/confirm_payment_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/routes.dart';
import 'package:yemenshop/features/authentication/presentation/pages/payment_done.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  @override
  _ConfirmPaymentScreenState createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';
  String _cardHolder = '';
  String _selectedCard = 'Visa';
  final List<String> _cardTypes = ['Visa', 'MasterCard', 'PayPal'];

  final TextEditingController _expiryController = TextEditingController();

  @override
  void dispose() {
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('ar'),
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (ctx, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
    );
    if (picked != null) {
      final formatted = intl.DateFormat('MM/yy').format(picked);
      setState(() {
        _expiryDate = formatted;
        _expiryController.text = formatted;
      });
    }
  }

  void _onPay() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      Navigator.pushReplacementNamed(context, AppRoutes.paymentSuccess);
    }
  }

  /// Wraps [child] in the app’s primary gradient outline
  Widget _withGradientOutline({required Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.normal),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.normal - 2),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('الدفع بالبطاقة'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1) Card Preview — filled with primary gradient
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                ),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          _selectedCard,
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _cardNumber.isEmpty
                            ? 'xxxx xxxx xxxx xxxx'
                            : _cardNumber,
                        style: AppTextStyles.h2.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _cardHolder.isEmpty
                                  ? 'اسم صاحب البطاقة'
                                  : _cardHolder,
                              style: AppTextStyles.body1
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Text(
                            _expiryDate.isEmpty ? 'MM/YY' : _expiryDate,
                            style: AppTextStyles.body1
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // 2) Card Type Selector — outlined or filled with gradient
              Text(
                'اختر نوع البطاقة',
                style:
                    AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: _cardTypes.map((type) {
                  final isSelected = type == _selectedCard;
                  final label = Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Text(
                        type,
                        style: AppTextStyles.body2.copyWith(
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCard = type),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs),
                        child: isSelected
                            ? DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.normal),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.normal),
                                  child: label,
                                ),
                              )
                            : _withGradientOutline(child: label),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.xl),

              // 3) Payment Form — all inputs outlined
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card Number
                    Text('رقم البطاقة', style: AppTextStyles.body2),
                    const SizedBox(height: AppSpacing.sm),
                    _withGradientOutline(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.sm,
                          ),
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        onSaved: (v) => _cardNumber = v ?? '',
                        validator: (v) {
                          if (v == null || v.replaceAll(' ', '').length < 16) {
                            return 'الرجاء إدخال رقم بطاقة صالح';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Expiry & CVV
                    Row(
                      children: [
                        // Expiry
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('تاريخ الانتهاء',
                                  style: AppTextStyles.body2),
                              const SizedBox(height: AppSpacing.sm),
                              _withGradientOutline(
                                child: TextFormField(
                                  controller: _expiryController,
                                  readOnly: true,
                                  onTap: () => _selectExpiryDate(context),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.sm,
                                    ),
                                    hintText: 'MM/YY',
                                  ),
                                  validator: (v) {
                                    if (v == null ||
                                        !RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$')
                                            .hasMatch(v)) {
                                      return 'MM/YY';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        // CVV
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CVV', style: AppTextStyles.body2),
                              const SizedBox(height: AppSpacing.sm),
                              _withGradientOutline(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.sm,
                                    ),
                                    hintText: 'XXX',
                                  ),
                                  onSaved: (v) => _cvv = v ?? '',
                                  validator: (v) {
                                    if (v == null || v.length < 3) {
                                      return 'XXX';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Card Holder
                    Text('اسم صاحب البطاقة', style: AppTextStyles.body2),
                    const SizedBox(height: AppSpacing.sm),
                    _withGradientOutline(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.sm,
                          ),
                          hintText: 'الاسم الكامل',
                        ),
                        onSaved: (v) => _cardHolder = v ?? '',
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'الرجاء إدخال الاسم';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // 4) Pay Button — gradient filled
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                      child: ElevatedButton(
                        onPressed: _onPay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.normal),
                          ),
                        ),
                        child: const Text(
                          'ادفع الآن',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
