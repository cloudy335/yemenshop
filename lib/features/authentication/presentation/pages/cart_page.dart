// lib/features/cart/screens/cart_screen_ui.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/core/theme/design_system.dart';

// نموذج بيانات عنصر السلة مع مسار الصورة
class CartItem {
  final String id;
  final String name;
  final String imagePath;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.quantity,
    required this.price,
  });

  double get lineTotal => price * quantity;
}

class CartScreenUI extends StatelessWidget {
  final List<CartItem> items;
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double totalCost;
  final void Function(String itemId, int change) onQuantityChanged;
  final void Function(String itemId) onRemoveItem;
  final void Function(CartItem removedItem) onUndoRemove;
  final void Function(String code) onApplyPromoCode;
  final VoidCallback onCheckout;

  const CartScreenUI({
    Key? key,
    required this.items,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalCost,
    required this.onQuantityChanged,
    required this.onRemoveItem,
    required this.onUndoRemove,
    required this.onApplyPromoCode,
    required this.onCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'سلتي',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'سلتك فارغة حالياً.',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : Column(
              children: [
                // قائمة المنتجات في السلة
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.md,
                      bottom: AppSpacing.md,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          final removedItem = item;
                          onRemoveItem(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم حذف "${item.name}"',
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              backgroundColor: AppColors.error,
                              action: SnackBarAction(
                                label: 'تراجع',
                                textColor: AppColors.textOnPrimary,
                                onPressed: () {
                                  onUndoRemove(removedItem);
                                },
                              ),
                            ),
                          );
                        },
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                            horizontal: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius:
                                BorderRadius.circular(AppRadius.normal),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppColors.textOnPrimary,
                            size: 28,
                          ),
                        ),
                        child: _CartItemWidget(
                          item: item,
                          onQuantityChanged: (change) =>
                              onQuantityChanged(item.id, change),
                        ),
                      );
                    },
                  ),
                ),

                // بطاقة الفاتورة (Invoice) + زر الدفع
                _InvoiceSummaryCard(
                  subTotal: subTotal,
                  deliveryFee: deliveryFee,
                  discount: discount,
                  totalCost: totalCost,
                  onApplyPromoCode: onApplyPromoCode,
                  onCheckout: onCheckout,
                ),
              ],
            ),
    );
  }
}

// === عنصر واحد داخل السلة مع صورة المنتج وتحرير الكمية ===
class _CartItemWidget extends StatelessWidget {
  final CartItem item;
  final void Function(int change) onQuantityChanged;

  const _CartItemWidget({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.normal),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // صورة المنتج
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.normal),
                color: AppColors.surface,
                image: DecorationImage(
                  image: AssetImage(item.imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // تفاصيل المنتج (الاسم والسعر ووحدة السعر)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سعر الوحدة: \$${item.price.toStringAsFixed(2)}',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الإجمالي: \$${item.lineTotal.toStringAsFixed(2)}',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // أزرار تعديل الكمية
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.normal),
                color: AppColors.surface,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                    onPressed:
                        item.quantity > 1 ? () => onQuantityChanged(-1) : null,
                  ),
                  Text(
                    '${item.quantity}',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                    onPressed: () => onQuantityChanged(1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === بطاقة الفاتورة (Invoice) مع ملخص الأسعار وزر الدفع ===
class _InvoiceSummaryCard extends StatefulWidget {
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double totalCost;
  final void Function(String code) onApplyPromoCode;
  final VoidCallback onCheckout;

  const _InvoiceSummaryCard({
    Key? key,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalCost,
    required this.onApplyPromoCode,
    required this.onCheckout,
  }) : super(key: key);

  @override
  State<_InvoiceSummaryCard> createState() => _InvoiceSummaryCardState();
}

class _InvoiceSummaryCardState extends State<_InvoiceSummaryCard> {
  final TextEditingController _promoController = TextEditingController();
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitPromo() {
    final code = _promoController.text.trim();
    if (code.isNotEmpty) {
      widget.onApplyPromoCode(code);
      _promoController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // تصميم حقل كود العرض
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                    boxShadow: _isFocused
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _promoController,
                      focusNode: _focusNode,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'أدخل رمز العرض',
                        hintStyle: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.normal),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.normal),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                      ),
                      onSubmitted: (_) => _submitPromo(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 100,
                child: AppButton(
                  label: 'تطبيق',
                  onPressed: _submitPromo,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // سطر المجموع الفرعي
          _buildInvoiceRow('المجموع الفرعي', widget.subTotal),
          const SizedBox(height: AppSpacing.sm),
          // سطر رسوم التوصيل
          _buildInvoiceRow('رسوم التوصيل', widget.deliveryFee),
          const SizedBox(height: AppSpacing.sm),
          // سطر الخصم (إذا وُجد)
          if (widget.discount > 0) ...[
            _buildInvoiceRow('الخصم', -widget.discount, isDiscount: true),
            const SizedBox(height: AppSpacing.sm),
          ],

          const Divider(
            height: AppSpacing.lg * 1.5,
            thickness: 1.5,
            color: AppColors.textSecondary,
          ),

          // سطر التكلفة الإجمالية
          _buildInvoiceRow(
            'التكلفة الإجمالية',
            widget.totalCost,
            isTotal: true,
          ),
          const SizedBox(height: AppSpacing.lg),

          // زرّ المتابعة إلى الدفع
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'المتابعة إلى الدفع',
              onPressed: widget.onCheckout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(
    String label,
    double value, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    final colorText = isDiscount ? AppColors.primary : AppColors.textPrimary;
    final valueText = isDiscount
        ? '-\$${value.abs().toStringAsFixed(2)}'
        : '\$${value.toStringAsFixed(2)}';

    final valueStyle = (isTotal
            ? AppTextStyles.h2.copyWith(color: colorText)
            : AppTextStyles.body1.copyWith(color: colorText))
        .copyWith(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal);

    final labelStyle = isTotal
        ? AppTextStyles.h2.copyWith(color: AppColors.textPrimary)
        : AppTextStyles.body2.copyWith(color: AppColors.textSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle,
            textDirection: TextDirection.rtl,
          ),
          Text(
            valueText,
            style: valueStyle,
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}
