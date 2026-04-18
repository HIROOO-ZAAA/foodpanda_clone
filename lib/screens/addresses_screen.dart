import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/profile.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});
  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late TextEditingController street, building, city, postal, notes;
  late String label;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileState>().profile;
    street = TextEditingController(text: p.street);
    building = TextEditingController(text: p.building);
    city = TextEditingController(text: p.city);
    postal = TextEditingController(text: p.postalCode);
    notes = TextEditingController(text: p.notes);
    label = p.label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Address'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: ['Home', 'Work', 'Other']
                .map((l) => ChoiceChip(
                      label: Text(l),
                      selected: label == l,
                      onSelected: (_) => setState(() => label = l),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(color: label == l ? Colors.white : AppColors.foreground),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          _f('Street address', street),
          _f('Apt / Building / Floor', building),
          _f('City / Area', city),
          _f('Postal code', postal),
          _f('Notes for the driver', notes, maxLines: 3),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(48)),
            onPressed: () {
              context.read<ProfileState>().update(
                label: label, street: street.text, building: building.text, city: city.text, postalCode: postal.text, notes: notes.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Address saved')));
              context.pop();
            },
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }

  Widget _f(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c, maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
