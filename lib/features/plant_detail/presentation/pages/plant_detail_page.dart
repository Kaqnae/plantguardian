import 'package:flutter/material.dart';
import 'package:plantguardian/features/plant_detail/data/delete_custom_plants_api.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/widgets/plant_form.dart';

class PlantDetailPage extends StatefulWidget {
  final CustomPlantModel plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController descController;
  late TextEditingController potVolumeController;
  late TextEditingController requiredWaterController;

  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.plant.name);
    typeController = TextEditingController(
      text: widget.plant.genericPlantModel.category,
    );
    descController = TextEditingController(
      text: widget.plant.genericPlantModel.desc,
    );
    potVolumeController = TextEditingController(
      text: widget.plant.potVolume.toString(),
    );
    requiredWaterController = TextEditingController(
      text: widget.plant.requiredWater.toString(),
    );
  }

  Future<void> deletePlant() async {
    try {
      await DeleteCustomPlantsApi().deleteCustomPlant(widget.plant.id);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fejl ved sletning: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.plant.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PlantForm(
              nameController: nameController,
              typeController: typeController,
              descController: descController,
              potVolumeController: potVolumeController,
              requiredWaterController: requiredWaterController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: implement save/update logic
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: deletePlant,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
