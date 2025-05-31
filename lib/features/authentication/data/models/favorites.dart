// lib/models/favorite_item.dart

class FavoriteItem {
  final String id;
  final String imagePath;
  final String title;
  final String price;

  bool isFavorite;

  FavoriteItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.price,
    this.isFavorite = false,
  });

  /// Create a FavoriteItem from a JSON-like map
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      title: json['title'] as String,
      price: json['price'] as String,
    );
  }

  /// Serialize this FavoriteItem to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'price': price,
    };
  }

  /// Two FavoriteItems are equal if their ids match
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
