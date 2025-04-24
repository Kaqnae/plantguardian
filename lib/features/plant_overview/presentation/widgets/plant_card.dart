import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/plant_model.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;

  const PlantCard({super.key, required this.plant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(plant.name),
        subtitle: Text('${plant.type} • ${plant.lastWatered}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
