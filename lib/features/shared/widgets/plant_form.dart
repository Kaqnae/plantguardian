import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/widgets/plant_textfields.dart';

class PlantForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descController;

  const PlantForm({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlantTextfields(controller: nameController, label: 'Name'),
        PlantTextfields(controller: typeController, label: 'Type'),
        PlantTextfields(controller: descController, label: 'Description'),
      ],
    );
  }
}
