import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<Product> products = [
    Product(id: 'p1', title: 'RAM DDR3 8GB', price: 350000, imageUrl: 'assets/images/ram1.jpg'),
    Product(id: 'p2', title: 'RAM DDR4 8GB', price: 650000, imageUrl: 'assets/images/ram2.jpg'),
    Product(id: 'p3', title: 'RAM DDR4 16GB', price: 650000, imageUrl: 'assets/images/ram3.jpg'),
    Product(id: 'p4', title: 'RAM DDR5 16GB', price: 650000, imageUrl: 'assets/images/ram4.jpeg'),
    // tambahkan produk lain di sini
  ];

  // alias supaya cart_page.dart yang pakai nama berbeda tetap jalan
  List<Product> get availableProducts => products;

  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => _items;

  double get totalPrice {
    double total = 0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}