// lib/features/cart/data/models/cart.dart

import 'package:collection/collection.dart';
import 'cart_item.dart';

class Cart {
  /// All items currently in the cart.
  final List<CartItem> items;

  /// Flat delivery fee (e.g. shipping).
  double deliveryFee;

  /// Flat discount applied to the entire cart (e.g. coupon).
  double discount;

  Cart({
    List<CartItem>? items,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
  }) : items = items ?? [];

  /// Sum of every CartItem.lineTotal.
  double get subTotal {
    return items.fold(0.0, (sum, item) => sum + item.lineTotal);
  }

  /// subTotal + deliveryFee – discount.
  double get totalCost {
    final raw = subTotal + deliveryFee - discount;
    return raw < 0.0 ? 0.0 : raw;
  }

  /// Add a new item. If an item with the same ID exists, bump its quantity.
  void addItem(CartItem newItem) {
    final existing = items.firstWhereOrNull((it) => it.id == newItem.id);
    if (existing != null) {
      existing.increment();
    } else {
      items.add(newItem);
    }
  }

  /// Remove exactly one quantity of the given item ID.
  /// If quantity would drop to zero, remove that line entirely.
  void removeOne(String itemId) {
    final existing = items.firstWhereOrNull((it) => it.id == itemId);
    if (existing != null) {
      if (existing.quantity > 1) {
        existing.decrement();
      } else {
        items.remove(existing);
      }
    }
  }

  /// Remove the entire line (all quantities) of itemId.
  void removeLine(String itemId) {
    items.removeWhere((it) => it.id == itemId);
  }

  /// Update an item's quantity to exactly [newQuantity].
  /// If newQuantity ≤ 0, remove that line.
  void updateQuantity(String itemId, int newQuantity) {
    final existing = items.firstWhereOrNull((it) => it.id == itemId);
    if (existing != null) {
      if (newQuantity <= 0) {
        items.remove(existing);
      } else {
        existing.quantity = newQuantity;
      }
    }
  }

  /// Apply a flat [amount] discount (e.g. coupon).
  void applyDiscount(double amount) {
    discount = amount;
  }

  /// Clear everything (lines, fees, discounts).
  void clear() {
    items.clear();
    deliveryFee = 0.0;
    discount = 0.0;
  }
}
