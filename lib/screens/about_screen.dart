import 'package:flutter/material.dart';
import '../theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🐼 Foodpanda Clone', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Flutter port of the Lovable demo app.\nBuilt with Material 3 + provider.', style: TextStyle(color: AppColors.muted)),
            SizedBox(height: 24),
            Text('Version 1.0.0'),
          ],
        ),
      ),
    );
  }
}
