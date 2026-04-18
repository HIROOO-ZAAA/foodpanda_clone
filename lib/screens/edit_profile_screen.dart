import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController name, email, phone, bio;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileState>().profile;
    name = TextEditingController(text: p.name);
    email = TextEditingController(text: p.email);
    phone = TextEditingController(text: p.phone);
    bio = TextEditingController(text: p.bio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field('Name', name),
          _field('Email', email),
          _field('Phone', phone),
          _field('Bio', bio, maxLines: 3),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(48)),
            onPressed: () {
              context.read<ProfileState>().update(
                name: name.text, email: email.text, phone: phone.text, bio: bio.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
              context.pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
