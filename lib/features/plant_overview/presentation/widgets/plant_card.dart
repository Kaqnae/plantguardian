import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';

class PlantCard extends StatelessWidget {
  final CustomPlantModel plant;
  final VoidCallback onTap;

  const PlantCard({super.key, required this.plant, required this.onTap});

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
