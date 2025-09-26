import 'package:flutter/foundation.dart';
import '../models/service.dart';
import '../models/order.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addItem(Service service, {Map<String, dynamic>? options}) {
    final existingIndex = _items.indexWhere((item) =>
        item.service.id == service.id &&
        _mapsEqual(item.selectedOptions, options ?? {}));

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(
        service: service,
        quantity: 1,
        selectedOptions: options ?? {},
      ));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length && quantity > 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Order createOrder() {
    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(_items),
      totalAmount: totalAmount,
      createdAt: DateTime.now(),
    );
  }

  bool _mapsEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
    }
    return true;
  }
}