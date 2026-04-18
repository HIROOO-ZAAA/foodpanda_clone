import 'package:flutter/foundation.dart';

class Profile {
  String name;
  String email;
  String phone;
  String bio;
  String label;
  String street;
  String building;
  String city;
  String postalCode;
  String notes;

  Profile({
    this.name = 'John Doe',
    this.email = 'john.doe@email.com',
    this.phone = '+1 555 123 4567',
    this.bio = 'Food lover & explorer 🍜',
    this.label = 'Home',
    this.street = '123 Main Street',
    this.building = 'Apt 4B, Floor 2',
    this.city = 'Downtown, New York',
    this.postalCode = '10001',
    this.notes = 'Ring the bell at the gate. Blue door.',
  });

  String get fullAddress => [street, building, city, postalCode]
      .where((s) => s.trim().isNotEmpty)
      .join(', ');
}

class ProfileState extends ChangeNotifier {
  final Profile profile = Profile();

  void update({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? label,
    String? street,
    String? building,
    String? city,
    String? postalCode,
    String? notes,
  }) {
    if (name != null) profile.name = name;
    if (email != null) profile.email = email;
    if (phone != null) profile.phone = phone;
    if (bio != null) profile.bio = bio;
    if (label != null) profile.label = label;
    if (street != null) profile.street = street;
    if (building != null) profile.building = building;
    if (city != null) profile.city = city;
    if (postalCode != null) profile.postalCode = postalCode;
    if (notes != null) profile.notes = notes;
    notifyListeners();
  }
}
