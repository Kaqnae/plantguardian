import 'package:flutter/material.dart';
import 'package:plantguardian/features/plant_detail/data/delete_custom_plants_api.dart';
import 'package:plantguardian/features/plant_detail/data/update_custom_plants_api.dart';
import 'package:plantguardian/features/shared/models/generic_plant_model.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/widgets/plant_form.dart';
import 'package:plantguardian/features/plant_detail/data/metrics_socket_service.dart';

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
  late TextEditingController temperatureController;
  late TextEditingController moistureController;

  MetricsSocketService? _metricsSocketService;
  dynamic _latestMetric;

  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.plant.name);
    typeController = TextEditingController(
      text: widget.plant.genericPlantModel.category,
    );
    descController = TextEditingController(
      text: widget.plant.genericPlantModel.description,
    );
    potVolumeController = TextEditingController(
      text: widget.plant.potVolume.toString(),
    );
    requiredWaterController = TextEditingController(
      text: widget.plant.requiredWater.toString(),
    );

    temperatureController = TextEditingController();
    moistureController = TextEditingController();
    print('Widget plant id: ${widget.plant.id}');

    MetricsSocketService().connect(
      url: 'http://10.176.69.182:3000',
      roomId: widget.plant.id,
      onMetricNewData: (data) {
        setState(() {
          _latestMetric = data;
          if (data['temperature'] != null) {
            temperatureController.text = data['temperature'].toString();
          }
          if (data['moistureLevel'] != null) {
            moistureController.text = data['moistureLevel'].toString();
          }
        });
      },
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

  Future<void> updatePlant() async {
    try {
      final updatedPlant = CustomPlantModel(
        id: widget.plant.id,
        name: nameController.text,
        imageUrl: widget.plant.imageUrl,
        potVolume:
            int.tryParse(potVolumeController.text) ?? widget.plant.potVolume,
        requiredWater:
            int.tryParse(requiredWaterController.text) ??
            widget.plant.requiredWater,
        genericPlantModel: GenericPlantModel(
          id: widget.plant.genericPlantModel.id,
          latinName: widget.plant.genericPlantModel.latinName,
          description: descController.text,
          category: typeController.text,
          moistureMinVal: widget.plant.genericPlantModel.moistureMinVal,
          allowedDryPeriod: widget.plant.genericPlantModel.allowedDryPeriod,
          tempMinVal: widget.plant.genericPlantModel.tempMinVal,
          tempMaxVal: widget.plant.genericPlantModel.tempMaxVal,
        ),
      );

      await UpdateCustomPlantsApi().updateCustomPlant(updatedPlant);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fejl ved opdatering: $e')));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    descController.dispose();
    potVolumeController.dispose();
    requiredWaterController.dispose();
    temperatureController.dispose();
    moistureController.dispose();

    MetricsSocketService().disconnect();
    super.dispose();
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
              temperatureController: temperatureController,
              moistureController: moistureController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updatePlant();
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
