// lib/features/cart/data/models/cart_item.dart

class CartItem {
  final String id;
  final String name;
  final String imagePath;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
  });

  /// The total for this line (unit price × quantity).
  double get lineTotal => price * quantity;

  /// Increase the quantity by 1.
  void increment() {
    quantity += 1;
  }

  /// Decrease the quantity by 1 (but never go below 1).
  void decrement() {
    if (quantity > 1) {
      quantity -= 1;
    }
  }
}
