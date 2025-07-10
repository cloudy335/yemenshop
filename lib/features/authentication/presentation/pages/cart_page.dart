// lib/features/authentication/presentation/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yemenshop/features/authentication/presentation/pages/inovince_screen.dart';

/// نموذج بيانات عنصر السلة مع مسار الصورة
class CartItem {
  final String id;
  final String name;
  final String imagePath;

  // Mutable quantity so it can be updated
  int quantity;

  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.quantity,
    required this.price,
  });

  double get lineTotal => price * quantity;

  get description => null;
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

  void _showInvoiceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, controller) => Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.large),
            ),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: _InvoiceSummaryCard(
              subTotal: subTotal,
              deliveryFee: deliveryFee,
              discount: discount,
              totalCost: totalCost,
              onApplyPromoCode: onApplyPromoCode,
              onCheckout: () {
                // 1. Close bottom sheet
                Navigator.of(ctx).pop();
                // 2. Navigate to full InvoiceScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ModernInvoiceScreen(
                      items: items,
                      subTotal: subTotal,
                      deliveryFee: deliveryFee,
                      discount: discount,
                      totalCost: totalCost,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

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
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'سلتي',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.doc_text,
                size: 30,
              ),
              color: AppColors.primary,
              tooltip: 'ملخص الفاتورة',
              onPressed: () => _showInvoiceSheet(context),
            ),
          ],
        ),
        body: items.isEmpty
            ? Center(
                child: Text(
                  'سلتك فارغة حالياً.',
                  style: AppTextStyles.body2
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.right,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
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
                            style: AppTextStyles.body1
                                .copyWith(color: AppColors.textOnPrimary),
                          ),
                          backgroundColor: AppColors.error,
                          action: SnackBarAction(
                            label: 'تراجع',
                            textColor: AppColors.textOnPrimary,
                            onPressed: () => onUndoRemove(removedItem),
                          ),
                        ),
                      );
                    },
                    background: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm, horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                      alignment: Alignment.centerRight,
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: const Icon(Icons.delete_outline,
                          size: 28, color: AppColors.textOnPrimary),
                    ),
                    child: _ModernCartItemCard(
                      item: item,
                      onQuantityChanged: (delta) =>
                          onQuantityChanged(item.id, delta),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _ModernCartItemCard extends StatelessWidget {
  final CartItem item;
  final void Function(int change) onQuantityChanged;

  const _ModernCartItemCard({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 240, 240),
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 4,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.normal),
                child: Image.asset(
                  item.imagePath,
                  width: 94,
                  height: 94,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.body1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'السعر: ${item.price.toStringAsFixed(2)} ريال',
                      style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 13,
                          color: AppColors.secondary),
                    ),
                  ],
                ),
              ),

              // Smaller outlined counter
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: IconButton(
                        onPressed: item.quantity > 1
                            ? () => onQuantityChanged(-1)
                            : null,
                        icon: const Icon(Icons.remove, size: 16),
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily, fontSize: 15),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: IconButton(
                        onPressed: () => onQuantityChanged(1),
                        icon: const Icon(Icons.add, size: 16),
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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

/// ملخص الفاتورة (بدون Card Borders)
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
    _focusNode = FocusNode()
      ..addListener(() {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                                  offset: Offset(0, 4))
                            ]
                          : [],
                    ),
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _promoController,
                        focusNode: _focusNode,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'أدخل رمز العرض',
                          hintStyle: AppTextStyles.body2
                              .copyWith(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.normal),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.normal),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.sm),
                        ),
                        onSubmitted: (_) => _submitPromo(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 90,
                  height: 44,
                  child: AppButton(label: 'تطبيق', onPressed: _submitPromo),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInvoiceRow('المجموع الفرعي', widget.subTotal),
            const SizedBox(height: AppSpacing.sm),
            _buildInvoiceRow('رسوم التوصيل', widget.deliveryFee),
            const SizedBox(height: AppSpacing.sm),
            if (widget.discount > 0) ...[
              _buildInvoiceRow('الخصم', -widget.discount, isDiscount: true),
              const SizedBox(height: AppSpacing.md),
            ],
            const Divider(
                height: AppSpacing.md * 2,
                thickness: 1.2,
                color: AppColors.textSecondary),
            _buildInvoiceRow('الإجمالي الكلي', widget.totalCost, isTotal: true),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
                height: 44,
                child: AppButton(
                    label: 'المتابعة إلى الدفع', onPressed: widget.onCheckout)),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, double value,
      {bool isTotal = false, bool isDiscount = false}) {
    final colorText = isDiscount ? AppColors.primary : AppColors.textPrimary;
    final valueText = isDiscount
        ? '-\$${value.abs().toStringAsFixed(0)}'
        : '\$${value.toStringAsFixed(0)}';
    final valueStyle = isTotal
        ? AppTextStyles.body1
            .copyWith(color: colorText, fontWeight: FontWeight.bold)
        : AppTextStyles.body2.copyWith(color: colorText);
    final labelStyle = isTotal
        ? AppTextStyles.body2.copyWith(color: AppColors.textPrimary)
        : AppTextStyles.body2.copyWith(color: AppColors.textSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle, textAlign: TextAlign.right),
          Text(valueText, style: valueStyle, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
