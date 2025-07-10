import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/pages/cart_page.dart';
import 'package:yemenshop/features/authentication/presentation/pages/confirm_payment.dart';

class ModernInvoiceScreen extends StatelessWidget {
  final List<CartItem> items;
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double totalCost;
  final String? shippingAddress;
  final String? paymentMethod;
  const ModernInvoiceScreen({
    Key? key,
    required this.items,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalCost,
    this.shippingAddress,
    this.paymentMethod,
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

              // (2) INVOICE SUMMARY CARD (moved down)
              const SizedBox(height: AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
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

              // (3) Promo code (moved down)
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                  border: Border.all(color: AppColors.primary),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'أدخل رمز الخصم',
                    hintStyle: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 153, 151, 151),
                    ),
                    border: InputBorder.none,
                    suffix: TextButton(
                      onPressed: () {},
                      child: Text('تطبيق', style: AppTextStyles.body2),
                    ),
                  ),
                ),
              ),

              // (4) Confirm button
              const SizedBox(height: 90),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ConfirmPaymentScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
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
            ],
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
            borderRadius:
                BorderRadius.circular(AppRadius.normal), // increased radius
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
                    style: AppTextStyles.body2), // price below name
                if (item.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      item.description!,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
          Text('${value.toStringAsFixed(2)} ﷼', style: valueStyle),
        ],
      ),
    );
  }

  Widget _billDivider() {
    return Divider(color: Colors.grey.shade300, thickness: 1);
  }
}
