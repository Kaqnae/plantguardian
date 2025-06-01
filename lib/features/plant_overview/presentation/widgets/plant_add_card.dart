import 'package:flutter/material.dart';

/// Widget representing a card for adding a new plant.
/// When tapped, it triggers the provided [onTap] callback.
class PlantAddCard extends StatelessWidget {
  /// Callback function to execute when the card is tapped.
  final VoidCallback onTap;

  /// Creates a PlantAddCard widget.
  const PlantAddCard({super.key, required this.onTap});

  /// Builds the UI for the add plant card.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 65,
          child: Center(child: Icon(Icons.add_box_outlined, size: 30)),
        ),
      ),
    );
  }
}
