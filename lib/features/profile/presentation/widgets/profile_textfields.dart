import 'package:flutter/material.dart';

class ProfileTextfields extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const ProfileTextfields({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
