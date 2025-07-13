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
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('الفاتورة',
              style: AppTextStyles.h1.copyWith(
                color: theme.colorScheme.onBackground,
              )),
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
                style: AppTextStyles.h2
                    .copyWith(color: theme.colorScheme.onBackground),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...items.map((item) => _buildItemRow(item, theme)).toList(),

              // space before invoice card
              const SizedBox(height: 80),

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.normal * 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                    ),
                    child: Row(
                      // <— Force left-to-right child ordering
                      textDirection: TextDirection.ltr,
                      children: [
                        // "تطبيق" button on the left
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 36,
                              width: 60,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'تطبيق',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Input field on the right
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.right,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: theme.colorScheme.onBackground,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.sm,
                              ),
                              hintText: 'أدخل رمز الخصم',
                              hintStyle: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // (2) INVOICE SUMMARY CARD — thicker outline (3px)
              const SizedBox(height: 30),

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.normal * 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      color: theme.colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppRadius.normal * 1.2),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _billLine('المجموع الفرعي', subTotal, theme),
                        _billDivider(theme),
                        _billLine('رسوم التوصيل', deliveryFee, theme),
                        if (discount > 0) ...[
                          _billDivider(theme),
                          _billLine('الخصم', -discount, theme,
                              isDiscount: true),
                        ],
                        _billDivider(theme),
                        _billLine('الإجمالي', totalCost, theme, isTotal: true),
                      ],
                    ),
                  ),
                ),
              ),

              // extra spacing before promo input

              // (3) Promo code input — gradient outline, hint right, apply button on left
              // … inside build(), replace the promo section with:

// (3) Promo code input — gradient outline, hint right, apply button always on left

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
              child: const Text(
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

  Widget _buildItemRow(CartItem item, ThemeData theme) {
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
                Text(item.name,
                    style: AppTextStyles.body1.copyWith(
                      color: theme.colorScheme.onBackground,
                    )),
                const SizedBox(height: AppSpacing.xs),
                Text('${item.lineTotal.toStringAsFixed(2)} ﷼',
                    style: AppTextStyles.body2.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    )),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _billLine(String label, double value, ThemeData theme,
      {bool isTotal = false, bool isDiscount = false}) {
    final labelStyle = AppTextStyles.body2.copyWith(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: theme.colorScheme.onSurfaceVariant,
    );
    final formatted = '\$${value.abs().toStringAsFixed(0)}';
    final valueText = isDiscount ? '-$formatted' : formatted;
    final valueStyle = AppTextStyles.body1.copyWith(
      color: isTotal
          ? AppColors.primary
          : (isDiscount ? AppColors.error : theme.colorScheme.onBackground),
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

  Widget _billDivider(ThemeData theme) {
    return Divider(color: theme.dividerColor, thickness: 1);
  }
}
