// lib/features/authentication/presentation/pages/confirm_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/pages/payment_done.dart';
import 'package:yemenshop/routes.dart';

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
      _formKey.currentState?.save();
      Navigator.pushReplacementNamed(context, AppRoutes.paymentSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
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
              // Card Preview
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                ),
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
                      _cardNumber.isEmpty ? 'xxxx xxxx xxxx xxxx' : _cardNumber,
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _cardHolder.isEmpty ? 'Card Holder' : _cardHolder,
                            style: AppTextStyles.body1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        Text(
                          _expiryDate.isEmpty ? 'MM/YY' : _expiryDate,
                          style:
                              AppTextStyles.body1.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Card Type Selector
              Text(
                'اختر نوع البطاقة',
                style:
                    AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: _cardTypes.map((type) {
                  final isSel = type == _selectedCard;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCard = type),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs),
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color: isSel
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: Center(
                          child: Text(
                            type,
                            style: AppTextStyles.body2.copyWith(
                              color:
                                  isSel ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Payment Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card Number
                    Text('رقم البطاقة', style: AppTextStyles.body2),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'XXXX XXXX XXXX XXXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.normal),
                        ),
                      ),
                      onSaved: (v) => _cardNumber = v ?? '',
                      validator: (v) {
                        if (v == null || v.replaceAll(' ', '').length < 16) {
                          return 'الرجاء إدخال رقم بطاقة صالح';
                        }
                        return null;
                      },
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
                              TextFormField(
                                controller: _expiryController,
                                readOnly: true,
                                onTap: () => _selectExpiryDate(context),
                                decoration: InputDecoration(
                                  hintText: 'MM/YY',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.normal),
                                  ),
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
                              TextFormField(
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'XXX',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.normal),
                                  ),
                                ),
                                onSaved: (v) => _cvv = v ?? '',
                                validator: (v) {
                                  if (v == null || v.length < 3) {
                                    return 'XXX';
                                  }
                                  return null;
                                },
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
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'الاسم الكامل',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.normal),
                        ),
                      ),
                      onSaved: (v) => _cardHolder = v ?? '',
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Pay Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _onPay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.normal),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('ادفع الآن'),
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
