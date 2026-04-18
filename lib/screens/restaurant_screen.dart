import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../data/static_data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final r = restaurants.firstWhere((x) => x.id == id);
    final menu = foodItems.where((f) => f.restaurantId == id).toList();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(r.image, fit: BoxFit.cover),
              title: Text(r.name),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: menu.length,
              itemBuilder: (_, i) {
                final f = menu[i];
                return Card(
                  child: ListTile(
                    onTap: () => context.push('/food/${f.id}'),
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(f.image, width: 56, height: 56, fit: BoxFit.cover)),
                    title: Text(f.name),
                    subtitle: Text(f.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text('\$${f.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
