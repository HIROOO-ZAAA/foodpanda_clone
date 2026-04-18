import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/profile.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileState>().profile;
    final tiles = [
      ('Edit Profile', Icons.person_outline, '/edit-profile'),
      ('Addresses', Icons.location_on_outlined, '/addresses'),
      ('My Ratings', Icons.star_outline, '/ratings'),
      ('About', Icons.info_outline, '/about'),
    ];
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: pandaGradient(), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24))),
              child: Row(
                children: [
                  const CircleAvatar(radius: 32, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(profile.email, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => context.push('/edit-profile'), icon: const Icon(Icons.edit, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: tiles.map((t) => ListTile(
                  leading: Icon(t.$2, color: AppColors.primary),
                  title: Text(t.$1),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(t.$3),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
