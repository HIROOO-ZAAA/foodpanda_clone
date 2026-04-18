import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../data/static_data.dart';
import '../state/cart.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key, required this.id});
  final String id;
  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final f = foodItems.firstWhere((x) => x.id == widget.id);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(f.image, height: 240, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 8, left: 8,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_back, color: Colors.black)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(f.description, style: const TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 24),
                    Text('\$${f.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton.filledTonal(onPressed: () => setState(() => qty = (qty - 1).clamp(1, 99)), icon: const Icon(Icons.remove)),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        IconButton.filledTonal(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(50)),
                            onPressed: () {
                              final cart = context.read<CartState>();
                              for (var i = 0; i < qty; i++) {
                                cart.add(f);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                              context.pop();
                            },
                            child: Text('Add ${qty}x to cart'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
