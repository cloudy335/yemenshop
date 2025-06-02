// lib/features/authentication/presentation/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/core/theme/design_system.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl, // entire screen is RTL
      child: Scaffold(
        backgroundColor: AppColors.surface,
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
            textAlign: TextAlign.right,
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
                  textAlign: TextAlign.right,
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
                          const SizedBox(height: AppSpacing.md),
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
                                  textAlign: TextAlign.right,
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

                  // بطاقة الفاتورة (بارتفاع معتدل) + زر الدفع
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
    return Directionality(
      textDirection: TextDirection.rtl, // this card is also RTL
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        // Make background color slightly transparent:
        color: AppColors.background.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // صورة المنتج
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                  color: AppColors.surface,
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(15, 0, 0, 0),
                      blurRadius: 4,
                      offset: Offset(0, 1),
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
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سعر الوحدة: \$${item.price.toStringAsFixed(2)}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الإجمالي: \$${item.lineTotal.toStringAsFixed(2)}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              // أقل حجم ممكن: أزرار تعديل الكمية داخل دائرة خضراء بخلفية بيضاء
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: item.quantity > 1
                          ? () => onQuantityChanged(-1)
                          : null,
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${item.quantity}',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => onQuantityChanged(1),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
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

// === بطاقة الفاتورة (Invoice) مع ملخص الأسعار وزر الدفع (بارتفاع معتدل) ===
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        // Moderate padding to make it slightly taller (not too much)
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
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
            // صف إدخال رمز العرض
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
                      height: 44,
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
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.normal),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.normal),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        onSubmitted: (_) => _submitPromo(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 90, // slightly wider button
                  height: 44, // a bit taller
                  child: AppButton(
                    label: 'تطبيق',
                    onPressed: _submitPromo,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md), // moderate gap

            // صف المجموع الفرعي
            _buildInvoiceRow('المجموع الفرعي', widget.subTotal),
            const SizedBox(height: AppSpacing.sm),
            // صف رسوم التوصيل
            _buildInvoiceRow('رسوم التوصيل', widget.deliveryFee),
            const SizedBox(height: AppSpacing.sm),
            // صف الخصم (إذا وُجد)
            if (widget.discount > 0) ...[
              _buildInvoiceRow('الخصم', -widget.discount, isDiscount: true),
              const SizedBox(height: AppSpacing.md),
            ],

            const Divider(
              height: AppSpacing.md * 2,
              thickness: 1.2,
              color: AppColors.textSecondary,
            ),

            // صف الإجمالي الكلي بخط أسمك قليلًا
            _buildInvoiceRow(
              'الإجمالي الكلي',
              widget.totalCost,
              isTotal: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // زر المتابعة إلى الدفع
            SizedBox(
              width: double.infinity,
              height: 44, // a bit taller
              child: AppButton(
                label: 'المتابعة إلى الدفع',
                onPressed: widget.onCheckout,
              ),
            ),
          ],
        ),
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
        ? '-\$${value.abs().toStringAsFixed(0)}'
        : '\$${value.toStringAsFixed(0)}';

    final valueStyle = isTotal
        ? AppTextStyles.body1.copyWith(
            color: colorText,
            fontWeight: FontWeight.bold,
          )
        : AppTextStyles.body2.copyWith(color: colorText);

    final labelStyle = isTotal
        ? AppTextStyles.body2.copyWith(color: AppColors.textPrimary)
        : AppTextStyles.body2.copyWith(color: AppColors.textSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle,
            textAlign: TextAlign.right,
          ),
          Text(
            valueText,
            style: valueStyle,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
