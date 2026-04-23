import 'package:flutter/material.dart';
import '../models/models.dart';

const restaurants = <Restaurant>[
  Restaurant(
    id: 'r1',
    name: 'Pizza Palace',
    cuisine: 'Italian · Pizza',
    rating: 4.7,
    deliveryTime: '25-30 min',
    deliveryFee: 'Free delivery',
    image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
    promoted: true,
  ),
  Restaurant(
    id: 'r2',
    name: 'Sushi Master',
    cuisine: 'Japanese · Sushi',
    rating: 4.9,
    deliveryTime: '30-40 min',
    deliveryFee: '\$1.99',
    image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600',
  ),
  Restaurant(
    id: 'r3',
    name: 'Burger Hub',
    cuisine: 'American · Burgers',
    rating: 4.5,
    deliveryTime: '20-25 min',
    deliveryFee: 'Free delivery',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
  ),
  Restaurant(
    id: 'r4',
    name: 'Taco Fiesta',
    cuisine: 'Mexican · Tacos',
    rating: 4.6,
    deliveryTime: '25-35 min',
    deliveryFee: '\$2.49',
    image: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=600',
  ),
];

const categories = <Map<String, String>>[
  {'id': 'c1', 'name': 'Pizza', 'icon': '🍕'},
  {'id': 'c2', 'name': 'Burger', 'icon': '🍔'},
  {'id': 'c3', 'name': 'Sushi', 'icon': '🍣'},
  {'id': 'c4', 'name': 'Tacos', 'icon': '🌮'},
  {'id': 'c5', 'name': 'Drinks', 'icon': '🥤'},
  {'id': 'c6', 'name': 'Dessert', 'icon': '🍰'},
];

const foodItems = <FoodItem>[
  FoodItem(
    id: 'f1',
    name: 'Margherita Pizza',
    description: 'Classic pizza with tomato, mozzarella, and basil.',
    price: 12.99,
    image: 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=600',
    category: 'Pizza',
    restaurantId: 'r1',
  ),
  FoodItem(
    id: 'f2',
    name: 'Pepperoni Pizza',
    description: 'Loaded with pepperoni and melted mozzarella.',
    price: 14.49,
    image: 'https://imgs.search.brave.com/JcalKM3jpMnMKn97YkoTFheqJ5_jhtvvBIxVWLH7SxM/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTQ0/MjQxNzU4NS9waG90/by9wZXJzb24tZ2V0/dGluZy1hLXBpZWNl/LW9mLWNoZWVzeS1w/ZXBwZXJvbmktcGl6/emEud2VicD9hPTEm/Yj0xJnM9NjEyeDYx/MiZ3PTAmaz0yMCZj/PWFrRUlKZHJZblUx/X2lEWmp2WnlOZFE3/Q3NZTHV6OE5UWW5q/Q3hUM1VBNGc9?w=600',    category: 'Pizza',
    restaurantId: 'r1',
  ),
  FoodItem(
    id: 'f3',
    name: 'Salmon Nigiri',
    description: 'Fresh salmon over seasoned sushi rice.',
    price: 9.99,
    image: 'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=600',
    category: 'Sushi',
    restaurantId: 'r2',
  ),
  FoodItem(
    id: 'f4',
    name: 'Classic Cheeseburger',
    description: 'Beef patty, cheddar, lettuce, tomato, special sauce.',
    price: 8.99,
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
    category: 'Burger',
    restaurantId: 'r3',
  ),
  FoodItem(
    id: 'f5',
    name: 'Beef Tacos (3)',
    description: 'Soft tortillas with seasoned beef and salsa.',
    price: 7.49,
    image: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600',
    category: 'Tacos',
    restaurantId: 'r4',
  ),
];

const promos = <Promo>[
  Promo(
    id: 1,
    title: '50% OFF',
    subtitle: 'On your first order!',
    code: 'WELCOME50',
    type: PromoType.percent,
    value: 50,
    description: '50% off your subtotal',
    gradient: [Color(0xFFD70F64), Color(0xFFFF8FB1)],
  ),
  Promo(
    id: 2,
    title: 'Free Delivery',
    subtitle: 'Orders above \$15',
    code: 'FREEDEL',
    type: PromoType.freeDelivery,
    value: 0,
    minSubtotal: 15,
    description: 'Free delivery on orders over \$15',
    gradient: [Color(0xFFFF8FB1), Color(0xFFF59E0B)],
  ),
  Promo(
    id: 3,
    title: 'Buy 1 Get 1',
    subtitle: 'Selected restaurants',
    code: 'BOGO2026',
    type: PromoType.bogo,
    value: 50,
    description: 'Effectively 50% off your subtotal',
    gradient: [Color(0xFFD70F64), Color(0xFFDC2626)],
  ),
  Promo(
    id: 4,
    title: '20% Cashback',
    subtitle: 'Pay with panda wallet',
    code: 'CASH20',
    type: PromoType.percent,
    value: 20,
    description: '20% off your subtotal',
    gradient: [Color(0xFF16A34A), Color(0xFFD70F64)],
  ),
];

AppliedTotals calculateTotals(double subtotal, double baseDeliveryFee, Promo? promo) {
  double deliveryFee = baseDeliveryFee;
  double discount = 0;
  String? reason;

  if (promo != null && subtotal > 0) {
    final meetsMin = promo.minSubtotal == null || subtotal >= promo.minSubtotal!;
    if (meetsMin) {
      if (promo.type == PromoType.percent || promo.type == PromoType.bogo) {
        discount = double.parse((subtotal * (promo.value / 100)).toStringAsFixed(2));
        reason = '${promo.code} applied';
      } else if (promo.type == PromoType.freeDelivery) {
        deliveryFee = 0;
        reason = '${promo.code} applied';
      }
    } else {
      final remaining = (promo.minSubtotal! - subtotal).toStringAsFixed(2);
      reason = 'Add \$$remaining more to use ${promo.code}';
    }
  }

  final total = (subtotal + deliveryFee - discount).clamp(0, double.infinity).toDouble();
  return AppliedTotals(
    subtotal: subtotal,
    deliveryFee: deliveryFee,
    discount: discount,
    total: total,
    reason: reason,
  );
}
