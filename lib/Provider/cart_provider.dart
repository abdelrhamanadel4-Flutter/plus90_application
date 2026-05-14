import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addItem({
    required String id,
    required String title,
    required double price,
    required String image,
    required double oldPrice,
  }) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existing) => existing.copyWith(quantity: existing.quantity + 1),
      );
    } else {
      _items[id] = CartItem(
        id: id,
        title: title,
        price: price,
        oldPrice: oldPrice,
        image: image,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void increaseQty(String id) {
    if (!_items.containsKey(id)) return;

    _items.update(
      id,
      (item) => item.copyWith(quantity: item.quantity + 1),
    );
    notifyListeners();
  }

  void decreaseQty(String id) {
    if (!_items.containsKey(id)) return;

    final item = _items[id]!;

    if (item.quantity > 1) {
      _items.update(
        id,
        (item) => item.copyWith(quantity: item.quantity - 1),
      );
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  int get itemCount => _items.length;
}

class CartItem {
  final String id;
  final String title;
  final double price;
  final double oldPrice;
  final String image;
  final int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.quantity,
  });

  CartItem copyWith({
    String? id,
    String? title,
    double? price,
    double? oldPrice,
    String? image,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }
}