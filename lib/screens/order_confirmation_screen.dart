import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: pandaGradient()),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(radius: 48, backgroundColor: Colors.white, child: Icon(Icons.check, color: AppColors.success, size: 48)),
                  const SizedBox(height: 24),
                  const Text('Order Confirmed!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Your food is being prepared', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 32),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, minimumSize: const Size.fromHeight(50)),
                    onPressed: () => context.go('/order-tracking'),
                    child: const Text('Track Order'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => context.go('/home'), child: const Text('Back to Home', style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
