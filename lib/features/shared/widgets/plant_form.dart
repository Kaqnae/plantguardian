import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/widgets/plant_textfields.dart';

class PlantForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descController;
  final TextEditingController potVolumeController;
  final TextEditingController requiredWaterController;

  final TextEditingController? temperatureController;
  final TextEditingController? moistureController;

  const PlantForm({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.descController,
    required this.potVolumeController,
    required this.requiredWaterController,
    this.temperatureController,
    this.moistureController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlantTextfields(controller: nameController, label: 'Name'),
        PlantTextfields(controller: typeController, label: 'Type'),
        PlantTextfields(controller: descController, label: 'Description'),
        PlantTextfields(
          controller: potVolumeController,
          label: 'Pot Volume (ml)',
        ),
        PlantTextfields(
          controller: requiredWaterController,
          label: 'Required Water (ml)',
        ),
        if (temperatureController != null)
          PlantTextfields(
            controller: temperatureController!,
            label: 'Temperature (°C)',
            readOnly: true,
          ),
        if (moistureController != null)
          PlantTextfields(
            controller: moistureController!,
            label: 'Moisture (%)',
            readOnly: true,
          ),
      ],
    );
  }
}
