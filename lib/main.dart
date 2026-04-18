import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'state/cart.dart';
import 'state/profile.dart';
import 'state/promo.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/restaurant_screen.dart';
import 'screens/food_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/addresses_screen.dart';
import 'screens/ratings_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const FoodApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/restaurant/:id', builder: (_, s) => RestaurantScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/food/:id', builder: (_, s) => FoodDetailScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
    GoRoute(path: '/order-confirmed', builder: (_, __) => const OrderConfirmationScreen()),
    GoRoute(path: '/order-tracking', builder: (_, __) => const OrderTrackingScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/edit-profile', builder: (_, __) => const EditProfileScreen()),
    GoRoute(path: '/addresses', builder: (_, __) => const AddressesScreen()),
    GoRoute(path: '/ratings', builder: (_, __) => const RatingsScreen()),
    GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
  ],
);

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartState()),
        ChangeNotifierProvider(create: (_) => ProfileState()),
        ChangeNotifierProvider(create: (_) => PromoState()),
      ],
      child: MaterialApp.router(
        title: 'Foodpanda Clone',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        routerConfig: _router,
      ),
    );
  }
}
