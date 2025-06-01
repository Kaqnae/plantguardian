import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';

/// Widget representing a card for displaying a custom plant.
/// Shows the plant's image (if available), name, and Latin name.
/// Tapping the card triggers the provided [onTap] callback.
class PlantCard extends StatelessWidget {
  /// The custom plant to display.
  final CustomPlantModel plant;

  /// Callback function to execute when the card is tapped.
  final VoidCallback onTap;

  /// Creates a PlantCard widget.
  const PlantCard({super.key, required this.plant, required this.onTap});

  /// Builds the UI for the plant card.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading:
            plant.imageUrl.isNotEmpty
                ? Image.file(
                  File(plant.imageUrl),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                : const Icon(Icons.local_florist, size: 40),
        title: Text(plant.name),
        subtitle: Text(plant.genericPlantModel.latinName),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
