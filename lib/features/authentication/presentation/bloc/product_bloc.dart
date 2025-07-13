import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProductDetails extends ProductEvent {
  final String productId;

  const LoadProductDetails({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ToggleFavorite extends ProductEvent {
  final FavoriteItem product;

  const ToggleFavorite({required this.product});

  @override
  List<Object?> get props => [product];
}

class LoadFavorites extends ProductEvent {}

// States
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<FavoriteItem> products;
  final List<FavoriteItem> favorites;

  const ProductsLoaded({
    required this.products,
    required this.favorites,
  });

  @override
  List<Object?> get props => [products, favorites];
}

class ProductDetailsLoaded extends ProductState {
  final FavoriteItem product;
  final bool isFavorite;

  const ProductDetailsLoaded({
    required this.product,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [product, isFavorite];
}

class FavoritesLoaded extends ProductState {
  final List<FavoriteItem> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  final List<FavoriteItem> _allProducts = [
    FavoriteItem(
      id: 'a',
      title: 'قهوة يمنية طازجة',
      imagePath: 'assets/images/coffee.png',
      price: '150 ريال',
    ),
    FavoriteItem(
      id: 'b',
      title: 'أفضل العسل اليمني',
      imagePath: 'assets/images/honey5.png',
      price: '200 ريال',
    ),
    FavoriteItem(
      id: 'c',
      title: 'قهوة عربية',
      imagePath: 'assets/images/coffee4.png',
      price: '100 ريال',
    ),
    FavoriteItem(
      id: 'f',
      title: 'ملابس تقليدية',
      imagePath: 'assets/images/clothes.png',
      price: '180 ريال',
    ),
    FavoriteItem(
      id: 'g',
      title: 'قهوة مختصة',
      imagePath: 'assets/images/coffee1.png',
      price: '170 ريال',
    ),
    FavoriteItem(
      id: 'h',
      title: 'عسل طبيعي',
      imagePath: 'assets/images/honey.png',
      price: '210 ريال',
    ),
    FavoriteItem(
      id: 'i',
      title: 'عسل نخب أول',
      imagePath: 'assets/images/honey1.png',
      price: '230 ريال',
    ),
    FavoriteItem(
      id: 'j',
      title: 'عسل مكرر',
      imagePath: 'assets/images/honey2.png',
      price: '190 ريال',
    ),
    FavoriteItem(
      id: 'k',
      title: 'جنبية يدوية',
      imagePath: 'assets/images/jambia.png',
      price: '250 ريال',
    ),
    FavoriteItem(
      id: 'n',
      title: 'ملابس نسائية',
      imagePath: 'assets/images/womenclothes.png',
      price: '220 ريال',
    ),
  ];

  final List<FavoriteItem> _favorites = [];

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(ProductsLoaded(
        products: List.from(_allProducts),
        favorites: List.from(_favorites),
      ));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      await Future.delayed(const Duration(milliseconds: 300));

      final product = _allProducts.firstWhere(
        (p) => p.id == event.productId,
        orElse: () => throw Exception('Product not found'),
      );

      final isFavorite = _favorites.any((f) => f.id == event.productId);

      emit(ProductDetailsLoaded(
        product: product,
        isFavorite: isFavorite,
      ));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final existingIndex =
          _favorites.indexWhere((f) => f.id == event.product.id);

      if (existingIndex >= 0) {
        _favorites.removeAt(existingIndex);
      } else {
        _favorites.add(event.product);
      }

      emit(ProductsLoaded(
        products: List.from(_allProducts),
        favorites: List.from(_favorites),
      ));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(FavoritesLoaded(favorites: List.from(_favorites)));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
