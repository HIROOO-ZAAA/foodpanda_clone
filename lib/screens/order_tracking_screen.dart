import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/profile.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});
  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int activeStep = 0;
  final steps = const [
    {'label': 'Order Confirmed', 'desc': 'Your order has been received', 'time': '12:30 PM'},
    {'label': 'Preparing', 'desc': 'Restaurant is preparing your food', 'time': '12:32 PM'},
    {'label': 'On the Way', 'desc': 'Driver is heading to you', 'time': '12:50 PM'},
    {'label': 'Delivered', 'desc': 'Enjoy your meal!', 'time': '1:05 PM'},
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => mounted ? setState(() => activeStep = 1) : null);
    Future.delayed(const Duration(seconds: 5), () => mounted ? setState(() => activeStep = 2) : null);
    Future.delayed(const Duration(seconds: 9), () => mounted ? setState(() => activeStep = 3) : null);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileState>().profile;
    final isDelivered = activeStep >= steps.length - 1;
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: isDelivered ? AppColors.success : AppColors.primary, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isDelivered ? 'ORDER DELIVERED ✓' : 'Estimated Delivery', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(isDelivered ? 'Completed · 1:05 PM' : '12:55 – 1:10 PM', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(steps.length, (i) {
              final isCompleted = i < activeStep || (i == steps.length - 1 && isDelivered);
              final isActive = i == activeStep && !(i == steps.length - 1 && isDelivered);
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: isCompleted ? AppColors.success : (isActive ? AppColors.primary : AppColors.secondary),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(isCompleted ? Icons.check : Icons.circle_outlined, color: Colors.white, size: 18),
                        ),
                        if (i < steps.length - 1)
                          Container(width: 2, height: 50, color: isCompleted ? AppColors.success : AppColors.secondary),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(steps[i]['label']!, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? AppColors.primary : AppColors.foreground)),
                              if (i == steps.length - 1 && isDelivered) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                  child: const Text('✓ DONE', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ]
                            ]),
                            Text(steps[i]['desc']!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [const Text('Delivering to', style: TextStyle(fontWeight: FontWeight.bold)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(profile.label.toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)))]),
                    const SizedBox(height: 12),
                    Text(profile.street, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${profile.building} · ${profile.city} · ${profile.postalCode}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text('${profile.name} · ${profile.phone}', style: const TextStyle(fontSize: 12)),
                    if (profile.notes.isNotEmpty) ...[
                      const Divider(height: 24),
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.sticky_note_2_outlined, size: 16, color: AppColors.muted), const SizedBox(width: 8), Expanded(child: Text(profile.notes, style: const TextStyle(fontSize: 12)))]),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isDelivered)
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.warning, minimumSize: const Size.fromHeight(48)),
                onPressed: () => context.push('/ratings'),
                icon: const Icon(Icons.star),
                label: const Text('Rate your order'),
              ),
            const SizedBox(height: 8),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(48)),
              onPressed: () => context.go('/home'),
              child: Text(isDelivered ? 'Order again' : 'Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
