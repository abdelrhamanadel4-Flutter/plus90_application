import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  /// Adds a product to the cart with stock validation.
  /// Returns an error message string if the validation fails, otherwise returns null.
  String? addItem({
    required String id,
    required String title,
    required double price,
    required String image,
    required double oldPrice,
    required String storeId,
    required int stock,
  }) {
    // Case 1: Item already exists in the cart
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity >= stock) {
        return "Sorry, the requested quantity exceeds available stock.";
      }
      _items.update(
        id,
        (existingItem) => existingItem.copyWith(quantity: existingItem.quantity + 1),
      );
    } 
    // Case 2: New item being added to the cart
    else {
      if (stock <= 0) {
        return "Sorry, this item is currently out of stock.";
      }
      _items[id] = CartItem(
        id: id,
        title: title,
        price: price,
        oldPrice: oldPrice,
        image: image,
        quantity: 1,
        storeId: storeId,
        stock: stock
      );
    }
    
    notifyListeners();
    return null; // Operation succeeded with no errors
  }

  /// Increases item quantity with stock validation.
  /// Returns an error message string if the validation fails, otherwise returns null.
  String? increaseQty(String id, int stock) {
    if (!_items.containsKey(id)) return null;

    if (_items[id]!.quantity >= stock) {
      return "Sorry, the requested quantity exceeds available stock.";
    }

    _items.update(
      id,
      (item) => item.copyWith(quantity: item.quantity + 1),
    );
    
    notifyListeners();
    return null; // Operation succeeded
  }

  /// Decreases item quantity or removes it if quantity becomes less than 1.
  void decreaseQty(String id) {
    if (!_items.containsKey(id)) return;

    final currentItem = _items[id]!;

    if (currentItem.quantity > 1) {
      _items.update(
        id,
        (item) => item.copyWith(quantity: item.quantity - 1),
      );
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  /// Removes an item completely from the cart.
  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  /// Clears all items from the cart.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Calculates the total price of all items in the cart.
  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  /// Returns the total number of unique items in the cart.
  int get itemCount => _items.length;
}

class CartItem {
  final String id;
  final String title;
  final double price;
  final double oldPrice;
  final String image;
  final int quantity;
  final String storeId;
  final int stock;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.quantity,
    required this.storeId,
    required this.stock,
  });

  CartItem copyWith({
    String? id,
    String? title,
    double? price,
    double? oldPrice,
    String? image,
    int? quantity,
    String? storeId,
    int? stock,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      storeId: storeId ?? this.storeId,
      stock: stock ?? this.stock,
    );


  }
}