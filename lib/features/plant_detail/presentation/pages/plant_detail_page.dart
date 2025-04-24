import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/plant_model.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: plant.name);
    final typeController = TextEditingController(text: plant.type);
    final descController = TextEditingController(text: plant.description);

    return Scaffold(
      appBar: AppBar(title: Text(plant.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save plant logic (update backend or local list later)
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
