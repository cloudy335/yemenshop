// lib/features/authentication/presentation/pages/modern_invoice_screen.dart

import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/pages/cart_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/confirm_payment.dart';

class ModernInvoiceScreen extends StatelessWidget {
  final List<CartItem> items;
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double totalCost;

  const ModernInvoiceScreen({
    Key? key,
    required this.items,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalCost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('الفاتورة', style: AppTextStyles.h1),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // (1) PRODUCTS
              Text(
                'المنتجات',
                style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...items.map(_buildItemRow).toList(),

              // space before invoice card
              const SizedBox(height: 80),

              // (2) INVOICE SUMMARY CARD — thicker outline (3px)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.large * 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.5), // thicker border
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppRadius.large * 1.2),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _billLine('المجموع الفرعي', subTotal),
                        _billDivider(),
                        _billLine('رسوم التوصيل', deliveryFee),
                        if (discount > 0) ...[
                          _billDivider(),
                          _billLine('الخصم', -discount, isDiscount: true),
                        ],
                        _billDivider(),
                        _billLine('الإجمالي', totalCost, isTotal: true),
                      ],
                    ),
                  ),
                ),
              ),

              // extra spacing before promo input
              const SizedBox(height: 30),

              // (3) Promo code input — thicker outline (3px)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.normal * 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'أدخل رمز الخصم',
                        hintStyle: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF999797),
                        ),
                        border: InputBorder.none,
                        suffix: TextButton(
                          onPressed: () {},
                          child: Text('تطبيق', style: AppTextStyles.body2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // bottom padding so content won't be hidden
              SizedBox(height: AppSpacing.xl * 2),
            ],
          ),
        ),

        // (4) Confirm button pinned at bottom
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ConfirmPaymentScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'تأكيد الدفع',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.normal),
            child: Image.asset(
              item.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.body1),
                const SizedBox(height: AppSpacing.xs),
                Text('${item.lineTotal.toStringAsFixed(2)} ﷼',
                    style: AppTextStyles.body2),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _billLine(String label, double value,
      {bool isTotal = false, bool isDiscount = false}) {
    final labelStyle = AppTextStyles.body2.copyWith(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: AppColors.textSecondary,
    );
    final formatted = '\$${value.abs().toStringAsFixed(0)}';
    final valueText = isDiscount ? '-$formatted' : formatted;
    final valueStyle = AppTextStyles.body1.copyWith(
      color: isTotal
          ? AppColors.primary
          : (isDiscount ? AppColors.error : AppColors.textPrimary),
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Text(label, style: labelStyle),
          const Spacer(),
          Text(valueText, style: valueStyle),
        ],
      ),
    );
  }

  Widget _billDivider() {
    return Divider(color: Colors.grey.shade300, thickness: 1);
  }
}
