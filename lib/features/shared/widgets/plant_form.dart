import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/widgets/plant_textfields.dart';

class PlantForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descController;
  final TextEditingController lastWateredController;

  const PlantForm({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.descController,
    required this.lastWateredController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlantTextfields(controller: nameController, label: 'Name'),
        PlantTextfields(controller: typeController, label: 'Type'),
        PlantTextfields(controller: descController, label: 'Description'),
        PlantTextfields(
          controller: lastWateredController,
          label: 'Last Watered',
        ),
      ],
    );
  }
}
