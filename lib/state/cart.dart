import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartState extends ChangeNotifier {
  final List<CartLine> _lines = [];
  List<CartLine> get lines => List.unmodifiable(_lines);

  int get totalItems => _lines.fold(0, (s, l) => s + l.quantity);
  double get totalPrice => _lines.fold(0.0, (s, l) => s + l.food.price * l.quantity);

  void add(FoodItem food) {
    final existing = _lines.indexWhere((l) => l.food.id == food.id);
    if (existing >= 0) {
      _lines[existing].quantity += 1;
    } else {
      _lines.add(CartLine(food: food));
    }
    notifyListeners();
  }

  void updateQuantity(String foodId, int qty) {
    if (qty <= 0) {
      _lines.removeWhere((l) => l.food.id == foodId);
    } else {
      final i = _lines.indexWhere((l) => l.food.id == foodId);
      if (i >= 0) _lines[i].quantity = qty;
    }
    notifyListeners();
  }

  void remove(String foodId) {
    _lines.removeWhere((l) => l.food.id == foodId);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
