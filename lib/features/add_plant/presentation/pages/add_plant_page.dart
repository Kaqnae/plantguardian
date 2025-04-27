import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/plant_model.dart';
import 'package:plantguardian/features/shared/widgets/plant_form.dart';

class AddPlantPage extends StatelessWidget {
  const AddPlantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final descController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Add a plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PlantForm(
              nameController: nameController,
              typeController: typeController,
              descController: descController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newPlant = {
                  'name': nameController.text,
                  'type': typeController.text,
                  'description': descController.text,
                };

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
