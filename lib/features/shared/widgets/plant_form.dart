import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/widgets/plant_textfields.dart';

/// Widget representing a form for entering or editing plant details.
/// Displays text fields for name, type, description, pot volume, required water,
/// and optionally allowed dry period and moisture minimum value.
class PlantForm extends StatelessWidget {
  /// Controller for the name text field.
  final TextEditingController nameController;

  /// Controller for the type text field.
  final TextEditingController typeController;

  /// Controller for the description text field.
  final TextEditingController descController;

  /// Controller for the pot volume text field.
  final TextEditingController potVolumeController;

  /// Controller for the required water text field.
  final TextEditingController requiredWaterController;

  /// Optional controller for the allowed dry period text field.
  final TextEditingController? allowedDryPeriodController;

  /// Optional controller for the moisture minimum value text field.
  final TextEditingController? moistureMinValController;

  /// Creates a PlantForm widget.
  const PlantForm({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.descController,
    required this.potVolumeController,
    required this.requiredWaterController,
    this.allowedDryPeriodController,
    this.moistureMinValController,
  });

  /// Builds the UI for the plant form.
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
        if (allowedDryPeriodController != null)
          PlantTextfields(
            controller: allowedDryPeriodController!,
            label: 'Allowed Dry Period (days)',
          ),
        if (moistureMinValController != null)
          PlantTextfields(
            controller: moistureMinValController!,
            label: 'Moisture Min Value (%)',
          ),
      ],
    );
  }
}
