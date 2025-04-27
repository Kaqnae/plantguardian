import 'package:flutter/material.dart';

class PlantTextfields extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const PlantTextfields({
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
