import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yemenshop/features/authentication/data/models/cart_item.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final CartItem item;

  const AddToCart({required this.item});

  @override
  List<Object?> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final String itemId;

  const RemoveFromCart({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateQuantity({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;

  const CartLoaded({required this.items, required this.total});

  @override
  List<Object?> get props => [items, total];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
  }

  final List<CartItem> _cartItems = [];

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final existingIndex =
          _cartItems.indexWhere((item) => item.id == event.item.id);

      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity += 1;
      } else {
        _cartItems.add(event.item);
      }

      final total = _cartItems.fold(
          0.0, (sum, item) => sum + (item.price * item.quantity));
      emit(CartLoaded(items: List.from(_cartItems), total: total));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      _cartItems.removeWhere((item) => item.id == event.itemId);
      final total = _cartItems.fold(
          0.0, (sum, item) => sum + (item.price * item.quantity));
      emit(CartLoaded(items: List.from(_cartItems), total: total));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final index = _cartItems.indexWhere((item) => item.id == event.itemId);
      if (index >= 0) {
        if (event.quantity <= 0) {
          _cartItems.removeAt(index);
        } else {
          _cartItems[index].quantity = event.quantity;
        }
      }
      final total = _cartItems.fold(
          0.0, (sum, item) => sum + (item.price * item.quantity));
      emit(CartLoaded(items: List.from(_cartItems), total: total));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      _cartItems.clear();
      emit(const CartLoaded(items: [], total: 0.0));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());
      // TODO: Load cart from local storage or API
      await Future.delayed(const Duration(milliseconds: 500));
      final total = _cartItems.fold(
          0.0, (sum, item) => sum + (item.price * item.quantity));
      emit(CartLoaded(items: List.from(_cartItems), total: total));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
