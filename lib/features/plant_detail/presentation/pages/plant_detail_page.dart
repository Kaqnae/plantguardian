import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/plant_model.dart';
import 'package:plantguardian/features/shared/widgets/plant_form.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: plant.name);
    final typeController = TextEditingController(text: plant.type);
    final descController = TextEditingController(text: plant.description);
    final lastWateredController = TextEditingController(
      text: plant.lastWatered,
    );

    return Scaffold(
      appBar: AppBar(title: Text(plant.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PlantForm(
              nameController: nameController,
              typeController: typeController,
              descController: descController,
              lastWateredController: lastWateredController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
