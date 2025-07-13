// lib/features/authentication/presentation/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/pages/inovince_screen.dart';

/// نموذج بيانات عنصر السلة مع مسار الصورة
class CartItem {
  final String id;
  final String name;
  final String imagePath;
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
    required this.onCheckout,
  }) : super(key: key);

  final List<CartItem> items;
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double totalCost;
  final void Function(String itemId, int change) onQuantityChanged;
  final void Function(String itemId) onRemoveItem;
  final void Function(CartItem removedItem) onUndoRemove;
  final VoidCallback onCheckout;

  void _showInvoiceSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);

        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            height: screenHeight * 0.30,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient, // centralized gradient
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(
                          top: AppSpacing.sm, bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _InvoiceSummaryCard(
                          subTotal: subTotal,
                          deliveryFee: deliveryFee,
                          discount: discount,
                          totalCost: totalCost,
                          onCheckout: () {
                            Navigator.of(ctx).pop();
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'سلتي',
            style: AppTextStyles.h2
                .copyWith(color: theme.colorScheme.onBackground),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'ملخص الفاتورة',
              onPressed: () => _showInvoiceSheet(context),
              icon: ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: const Icon(
                  CupertinoIcons.doc_text,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: items.isEmpty
            ? Center(
                child: Text(
                  'سلتك فارغة حالياً.',
                  style: AppTextStyles.body2
                      .copyWith(color: theme.colorScheme.onBackground),
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
                            onPressed: () => onUndoRemove(item),
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
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient, // centralized gradient
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.large),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 4,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
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
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'السعر: ${item.price.toStringAsFixed(2)} ريال',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 13,
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            gradient: AppColors
                                .primaryGradient, // centralized gradient
                            borderRadius:
                                BorderRadius.circular(AppRadius.small),
                          ),
                          child: IconButton(
                            onPressed: () => onQuantityChanged(-1),
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
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 15,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            gradient: AppColors
                                .primaryGradient, // centralized gradient
                            borderRadius:
                                BorderRadius.circular(AppRadius.small),
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
        ),
      ),
    );
  }
}

class _InvoiceSummaryCard extends StatelessWidget {
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double totalCost;
  final VoidCallback onCheckout;

  const _InvoiceSummaryCard({
    Key? key,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalCost,
    required this.onCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInvoiceRow('المجموع الفرعي', subTotal, theme),
            const SizedBox(height: AppSpacing.sm),
            _buildInvoiceRow('رسوم التوصيل', deliveryFee, theme),
            const SizedBox(height: AppSpacing.sm),
            if (discount > 0) ...[
              _buildInvoiceRow('الخصم', -discount, theme, isDiscount: true),
              const SizedBox(height: AppSpacing.md),
            ],
            Divider(
              height: AppSpacing.md * 2,
              thickness: 1.2,
              color: theme.colorScheme.onBackground.withOpacity(0.2),
            ),
            _buildInvoiceRow('الإجمالي الكلي', totalCost, theme, isTotal: true),
            const SizedBox(height: AppSpacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient, // centralized gradient
                borderRadius: BorderRadius.circular(AppRadius.normal),
              ),
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                  ),
                ),
                child: const Text(
                  'المتابعة إلى الدفع',
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
    );
  }

  Widget _buildInvoiceRow(String label, double value, ThemeData theme,
      {bool isTotal = false, bool isDiscount = false}) {
    final colorText =
        isDiscount ? theme.colorScheme.primary : theme.colorScheme.onBackground;
    final formatted = '﷼${value.abs().toStringAsFixed(2)}';
    final valueText = isDiscount ? '-$formatted' : formatted;
    final valueStyle = isTotal
        ? AppTextStyles.body1
            .copyWith(color: colorText, fontWeight: FontWeight.bold)
        : AppTextStyles.body2.copyWith(color: colorText);
    final labelStyle = isTotal
        ? AppTextStyles.body2.copyWith(color: theme.colorScheme.onBackground)
        : AppTextStyles.body2
            .copyWith(color: theme.colorScheme.onBackground.withOpacity(0.7));

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
