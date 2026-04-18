import 'package:flutter/foundation.dart';
import '../data/static_data.dart';
import '../models/models.dart';

class PromoState extends ChangeNotifier {
  Promo? _applied;
  Promo? get applied => _applied;

  void apply(Promo p) {
    _applied = p;
    notifyListeners();
  }

  Promo? applyByCode(String code) {
    final found = promos.where((p) => p.code.toLowerCase() == code.trim().toLowerCase());
    _applied = found.isEmpty ? null : found.first;
    notifyListeners();
    return _applied;
  }

  void clear() {
    _applied = null;
    notifyListeners();
  }
}
