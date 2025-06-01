import 'package:flutter/material.dart';

/// Widget for displaying a single plant text field with a label.
/// Can be set to read-only if needed.
class PlantTextfields extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController controller;

  /// Label to display above the text field.
  final String label;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// Creates a PlantTextfields widget.
  const PlantTextfields({
    super.key,
    required this.controller,
    required this.label,
    this.readOnly = false,
  });

  /// Builds the UI for the plant text field.
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: readOnly,
    );
  }
}
