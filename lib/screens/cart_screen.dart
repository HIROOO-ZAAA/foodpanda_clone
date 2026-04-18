import 'package:flutter/material.dart';
import 'package:foodpanda_clone/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/cart.dart';
import '../state/promo.dart';
import '../data/static_data.dart';
import '../widgets/bottom_nav.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();
    final promoState = context.watch<PromoState>();
    final baseDelivery = cart.lines.isNotEmpty ? 1.99 : 0.0;
    final totals = calculateTotals(cart.totalPrice, baseDelivery, promoState.applied);

    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          if (cart.lines.isNotEmpty)
            TextButton(onPressed: cart.clear, child: const Text('Clear all', style: TextStyle(color: AppColors.destructive))),
        ],
      ),
      body: cart.lines.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.muted),
                  const SizedBox(height: 12),
                  const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () => context.go('/home'),
                    child: const Text('Browse Restaurants'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...cart.lines.map((l) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(l.food.image, width: 70, height: 70, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l.food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('\$${(l.food.price * l.quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              IconButton(onPressed: () => cart.updateQuantity(l.food.id, l.quantity - 1), icon: const Icon(Icons.remove_circle_outline)),
                              Text('${l.quantity}'),
                              IconButton(onPressed: () => cart.updateQuantity(l.food.id, l.quantity + 1), icon: const Icon(Icons.add_circle, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 12),

                  // Promo
                  if (promoState.applied != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          border: Border.all(color: AppColors.success.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const CircleAvatar(backgroundColor: AppColors.success, radius: 16, child: Icon(Icons.check, color: Colors.white, size: 16)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${promoState.applied!.code} applied', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(totals.reason ?? promoState.applied!.description,
                                    style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                              ],
                            ),
                          ),
                          IconButton(onPressed: promoState.clear, icon: const Icon(Icons.close)),
                        ],
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _codeCtrl,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              hintText: 'Enter promo code',
                              prefixIcon: Icon(Icons.local_offer_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                          onPressed: () {
                            final found = promoState.applyByCode(_codeCtrl.text);
                            if (found != null) {
                              _codeCtrl.clear();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${found.code} applied')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid code')));
                            }
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _row('Subtotal', '\$${totals.subtotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 8),
                          _row('Delivery fee', totals.deliveryFee == 0 && promoState.applied?.type == PromoType.freeDelivery ? 'FREE' : '\$${totals.deliveryFee.toStringAsFixed(2)}'),
                          if (totals.discount > 0) ...[
                            const SizedBox(height: 8),
                            _row('Promo discount', '-\$${totals.discount.toStringAsFixed(2)}', valueColor: AppColors.success),
                          ],
                          const Divider(height: 24),
                          _row('Total', '\$${totals.total.toStringAsFixed(2)}', bold: true, big: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(52)),
                    onPressed: () {
                      cart.clear();
                      promoState.clear();
                      context.go('/order-confirmed');
                    },
                    child: Text('Place Order · \$${totals.total.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _row(String l, String r, {bool bold = false, bool big = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: big ? 16 : 14)),
        Text(r, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: big ? 18 : 14, color: valueColor ?? (bold ? AppColors.primary : AppColors.foreground))),
      ],
    );
  }
}
