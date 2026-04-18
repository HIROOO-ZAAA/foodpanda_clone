import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});
  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  int rating = 5;
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Order'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text('How was it?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < rating;
                return IconButton(
                  iconSize: 40,
                  onPressed: () => setState(() => rating = i + 1),
                  icon: Icon(filled ? Icons.star : Icons.star_border, color: AppColors.warning),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Tell us more (optional)', border: OutlineInputBorder()),
            ),
            const Spacer(),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanks for your feedback!')));
                context.go('/home');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
