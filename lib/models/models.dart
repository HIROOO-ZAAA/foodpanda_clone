import 'package:flutter/material.dart' show Color;

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final String deliveryTime;
  final String deliveryFee;
  final String image;
  final bool promoted;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.image,
    this.promoted = false,
  });
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final String restaurantId;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.restaurantId,
  });
}

class CartLine {
  final FoodItem food;
  int quantity;
  CartLine({required this.food, this.quantity = 1});
}

enum PromoType { percent, freeDelivery, bogo }

class Promo {
  final int id;
  final String title;
  final String subtitle;
  final String code;
  final PromoType type;
  final double value;
  final double? minSubtotal;
  final String description;
  final List<Color> gradient;

  const Promo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.type,
    required this.value,
    required this.description,
    required this.gradient,
    this.minSubtotal,
  });
}

class AppliedTotals {
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String? reason;
  AppliedTotals({
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    this.reason,
  });
}
