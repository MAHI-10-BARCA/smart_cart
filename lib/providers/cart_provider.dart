// lib/providers/cart_provider.dart

import 'package:flutter/foundation.dart';
// IMPORTANT: The import path now matches your file name
import '../models/product_model.dart'; 

class CartProvider with ChangeNotifier {
  final Map<String, Product> _items = {};

  List<Product> get cartItems {
    return _items.values.toList();
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price;
    });
    return total;
  }

  void addToCart(Product product) {
    _items.putIfAbsent(product.id, () => product);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
