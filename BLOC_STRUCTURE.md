# BLoC Architecture Implementation

## Overview

Your Flutter app has been organized according to the BLoC (Business Logic Component) pattern. This provides better separation of concerns, testability, and state management.

## BLoC Structure

### 1. Authentication BLoC (`auth_bloc.dart`)

**Purpose**: Handles user authentication, login, registration, and OTP verification.

**Events**:

- `LoginRequested` - User login
- `RegisterRequested` - User registration
- `OTPVerificationRequested` - OTP verification
- `LogoutRequested` - User logout
- `ResetPasswordRequested` - Password reset

**States**:

- `AuthInitial` - Initial state
- `AuthLoading` - Loading state
- `AuthSuccess` - Success with message
- `AuthFailure` - Error with message

### 2. Cart BLoC (`cart_bloc.dart`)

**Purpose**: Manages shopping cart operations.

**Events**:

- `AddToCart` - Add item to cart
- `RemoveFromCart` - Remove item from cart
- `UpdateQuantity` - Update item quantity
- `ClearCart` - Clear entire cart
- `LoadCart` - Load cart from storage

**States**:

- `CartInitial` - Initial state
- `CartLoading` - Loading state
- `CartLoaded` - Cart loaded with items and total
- `CartError` - Error state

### 3. Product BLoC (`product_bloc.dart`)

**Purpose**: Manages product listing, favorites, and product details.

**Events**:

- `LoadProducts` - Load all products
- `LoadProductDetails` - Load specific product details
- `ToggleFavorite` - Toggle product favorite status
- `LoadFavorites` - Load user favorites

**States**:

- `ProductInitial` - Initial state
- `ProductLoading` - Loading state
- `ProductsLoaded` - Products loaded with favorites
- `ProductDetailsLoaded` - Single product details loaded
- `FavoritesLoaded` - Favorites loaded
- `ProductError` - Error state

### 4. Theme BLoC (`theme_bloc.dart`)

**Purpose**: Manages app theme switching.

**Events**:

- `ThemeChanged` - Change theme mode
- `LoadTheme` - Load saved theme

**States**:

- `ThemeInitial` - Initial state
- `ThemeLoaded` - Theme loaded
- `ThemeError` - Error state

## How to Use BLoC in Screens

### Example: Using Product BLoC

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return CircularProgressIndicator();
        }

        if (state is ProductsLoaded) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              final isFavorite = state.favorites.contains(product);

              return ProductTile(
                product: product,
                isFavorite: isFavorite,
                onFavoriteToggle: () {
                  context.read<ProductBloc>().add(
                    ToggleFavorite(product: product),
                  );
                },
              );
            },
          );
        }

        return Text('No products found');
      },
    );
  }
}
```

### Example: Dispatching Events

```dart
// Add to cart
context.read<CartBloc>().add(AddToCart(item: cartItem));

// Toggle favorite
context.read<ProductBloc>().add(ToggleFavorite(product: product));

// Login
context.read<AuthBloc>().add(LoginRequested(
  phone: phoneController.text,
  password: passwordController.text,
));

// Change theme
context.read<ThemeBloc>().add(ThemeChanged(themeMode: ThemeMode.dark));
```

## Main App Setup

The main.dart has been updated to use `MultiBlocProvider`:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
    BlocProvider<CartBloc>(create: (context) => CartBloc()),
    BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
    BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
  ],
  child: const MyApp(),
),
```

## Benefits of BLoC Pattern

1. **Separation of Concerns**: Business logic is separated from UI
2. **Testability**: Each BLoC can be tested independently
3. **Predictable State Management**: State changes are predictable and traceable
4. **Reusability**: BLoCs can be reused across different screens
5. **Scalability**: Easy to add new features and maintain code

## Next Steps

1. **Update existing screens** to use BLoC instead of setState
2. **Add proper error handling** in BLoC methods
3. **Implement data persistence** (SharedPreferences, Hive, etc.)
4. **Add unit tests** for each BLoC
5. **Create repositories** for data layer abstraction

## File Structure

```
lib/
├── features/
│   └── authentication/
│       ├── presentation/
│       │   ├── bloc/
│       │   │   ├── auth_bloc.dart
│       │   │   ├── cart_bloc.dart
│       │   │   ├── product_bloc.dart
│       │   │   ├── theme_bloc.dart
│       │   │   └── blocs.dart
│       │   ├── pages/
│       │   └── widgets/
│       ├── domain/
│       └── data/
└── main.dart
```

## Dependencies Required

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
```

This BLoC implementation provides a solid foundation for your Yemen Shop app with proper state management and separation of concerns.
