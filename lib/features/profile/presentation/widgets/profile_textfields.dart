import 'package:flutter/material.dart';

/// Widget for displaying a single profile text field with a label.
/// Used in the profile form for user input.
class ProfileTextfields extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController controller;

  /// Label to display above the text field.
  final String label;

  /// Creates a ProfileTextfields widget.
  const ProfileTextfields({
    super.key,
    required this.controller,
    required this.label,
  });

  /// Builds the UI for the profile text field.
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
