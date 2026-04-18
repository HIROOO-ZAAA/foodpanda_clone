import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../data/static_data.dart';
import '../state/profile.dart';
import '../state/promo.dart';
import '../models/models.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _pageCtrl = PageController();
  int _currentPromo = 0;

  @override
  void initState() {
    super.initState();
    _autoAdvance();
  }

  void _autoAdvance() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      _currentPromo = (_currentPromo + 1) % promos.length;
      _pageCtrl.animateToPage(_currentPromo,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileState>().profile;
    final promoState = context.watch<PromoState>();
    final query = _searchCtrl.text.trim().toLowerCase();
    final searching = query.isNotEmpty;

    final filteredR = !searching
        ? restaurants
        : restaurants
            .where((r) => r.name.toLowerCase().contains(query) ||
                r.cuisine.toLowerCase().contains(query))
            .toList();
    final filteredF = !searching
        ? <FoodItem>[]
        : foodItems
            .where((f) => f.name.toLowerCase().contains(query) ||
                f.description.toLowerCase().contains(query))
            .toList();

    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                decoration: BoxDecoration(
                  gradient: pandaGradient(),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.push('/addresses'),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(profile.label,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.white70, size: 18),
                                  ],
                                ),
                                Text(profile.fullAddress,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search for restaurants or food...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searching
                            ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),

              // Promo carousel
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: SizedBox(
                  height: 130,
                  child: PageView.builder(
                    controller: _pageCtrl,
                    itemCount: promos.length,
                    onPageChanged: (i) => setState(() => _currentPromo = i),
                    itemBuilder: (_, i) {
                      final p = promos[i];
                      final applied = promoState.applied?.id == p.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            if (applied) {
                              promoState.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${p.code} removed')));
                            } else {
                              promoState.apply(p);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${p.code} applied — ${p.description}')));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(colors: p.gradient),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(p.title,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    if (applied)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: AppColors.success,
                                            borderRadius: BorderRadius.circular(20)),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.check, color: Colors.white, size: 12),
                                            SizedBox(width: 4),
                                            Text('APPLIED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(p.subtitle,
                                    style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Text(applied ? 'Tap to remove' : 'Tap to apply: ${p.code}',
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (!searching) ...[
                // Categories
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text("What's on your mind?",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => Column(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(child: Text(categories[i]['icon']!, style: const TextStyle(fontSize: 24))),
                        ),
                        const SizedBox(height: 6),
                        Text(categories[i]['name']!, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ),

                // Restaurants
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text('All restaurants',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurants.length,
                  itemBuilder: (_, i) => _restaurantCard(context, restaurants[i]),
                ),
              ] else ...[
                if (filteredR.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text('Restaurants', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ...filteredR.map((r) => _restaurantCard(context, r)),
                ],
                if (filteredF.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text('Food items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ...filteredF.map((f) => ListTile(
                        onTap: () => context.push('/food/${f.id}'),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(f.image, width: 56, height: 56, fit: BoxFit.cover)),
                        title: Text(f.name),
                        subtitle: Text(f.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Text('\$${f.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      )),
                ],
                if (filteredR.isEmpty && filteredF.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('No results found', style: TextStyle(color: AppColors.muted))),
                  ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _restaurantCard(BuildContext context, Restaurant r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/restaurant/${r.id}'),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(r.image, width: double.infinity, height: 160, fit: BoxFit.cover),
                  ),
                  if (r.promoted)
                    Positioned(
                      top: 12, left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('PROMOTED',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.success, size: 12),
                              const SizedBox(width: 2),
                              Text(r.rating.toString(),
                                  style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(r.cuisine, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Text(r.deliveryTime, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        const SizedBox(width: 12),
                        Text(r.deliveryFee,
                            style: TextStyle(
                                fontSize: 12,
                                color: r.deliveryFee == 'Free delivery' ? AppColors.primary : AppColors.muted,
                                fontWeight: r.deliveryFee == 'Free delivery' ? FontWeight.bold : FontWeight.normal)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
