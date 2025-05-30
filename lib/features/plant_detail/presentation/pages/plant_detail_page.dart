import 'package:flutter/material.dart';
import 'package:plantguardian/features/plant_detail/data/delete_custom_plants_api.dart';
import 'package:plantguardian/features/plant_detail/data/iot_config_socket_service.dart';
import 'package:plantguardian/features/plant_detail/data/update_custom_plants_api.dart';
import 'package:plantguardian/features/plant_detail/domain/iot_config_model.dart';
import 'package:plantguardian/features/shared/models/generic_plant_model.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/widgets/plant_form.dart';
import 'package:plantguardian/features/plant_detail/data/metrics_socket_service.dart';
import 'package:plantguardian/features/shared/widgets/plant_textfields.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlantDetailPage extends StatefulWidget {
  final CustomPlantModel plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  // Controllers for the plant details
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController descController;
  late TextEditingController potVolumeController;
  late TextEditingController requiredWaterController;
  late TextEditingController allowedDryPeriodController;
  late TextEditingController dateTimeController;
  late TextEditingController moistureController;
  late TextEditingController moistureMinValController;
  late TextEditingController waterLevelController;
  late TextEditingController lastWateredController;

  dynamic _latestMetric;

  /// Initialize the controllers with the plant's current data
  /// and set up the socket connection to receive live updates
  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current plant data

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
    allowedDryPeriodController = TextEditingController(
      text: widget.plant.genericPlantModel.allowedDryPeriod.toString(),
    );
    moistureMinValController = TextEditingController(
      text: widget.plant.genericPlantModel.moistureMinVal.toString(),
    );

    dateTimeController = TextEditingController();
    moistureController = TextEditingController();
    waterLevelController = TextEditingController();
    lastWateredController = TextEditingController();

    // Load last cached metrics before connecting to the socket
    MetricsSocketService.loadLatestMetric(widget.plant.id).then((lastMetric) {
      if (lastMetric != null) {
        if (lastMetric['dateTimeStamp'] != null) {
          dateTimeController.text = formatDateTime(
            lastMetric['dateTimeStamp'].toString(),
          );
        }
        if (lastMetric['moistureLevel'] != null) {
          moistureController.text = lastMetric['moistureLevel'].toString();
        }
        if (lastMetric['waterLevel'] != null) {
          waterLevelController.text = lastMetric['waterLevel'].toString();
        }
        if (lastMetric['lastWatered'] != null) {
          lastWateredController.text = formatDateTime(
            lastMetric['lastWatered'].toString(),
          );
        }
      }
    });

    // Connect to the metrics socket service to receive live updates
    MetricsSocketService().connect(
      url: '${dotenv.env['API_SOCKET_URL']}',
      roomId: widget.plant.id,
      onMetricNewData: (data) {
        setState(() {
          _latestMetric = data;
          if (data['dateTimeStamp'] != null) {
            dateTimeController.text = formatDateTime(
              data['dateTimeStamp'].toString(),
            );
          }
          if (data['moistureLevel'] != null) {
            moistureController.text = data['moistureLevel'].toString();
          }
          if (data['waterLevel'] != null) {
            waterLevelController.text = data['waterLevel'].toString();
          }
          if (data['lastWatered'] != null) {
            lastWateredController.text = formatDateTime(
              data['lastWatered'].toString(),
            );
          }
        });
      },
    );
  }

  /// Helper function to format ISO date strings
  /// Returns a formatted date string or the original string if parsing fails
  String formatDateTime(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    } catch (e) {
      return isoString;
    }
  }

  /// Function to delete the current plant
  /// Shows a snackbar if deleting fails
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

  /// Function to update the plant with the current data from the controllers
  /// Sends the updated plant data to the API and updates the IoT config
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
          moistureMinVal:
              int.tryParse(moistureMinValController.text) ??
              widget.plant.genericPlantModel.moistureMinVal,
          allowedDryPeriod:
              int.tryParse(allowedDryPeriodController.text) ??
              widget.plant.genericPlantModel.allowedDryPeriod,
          tempMinVal: widget.plant.genericPlantModel.tempMinVal,
          tempMaxVal: widget.plant.genericPlantModel.tempMaxVal,
        ),
      );

      await UpdateCustomPlantsApi().updateCustomPlant(updatedPlant);

      final iotConfig = IotConfigModel(
        customPlantId: widget.plant.id,
        moistureMinVal: double.tryParse(moistureMinValController.text) ?? 0.0,
        allowedDryPeriod:
            double.tryParse(allowedDryPeriodController.text) ?? 0.0,
        requiredWater: double.tryParse(requiredWaterController.text) ?? 0.0,
      );

      IotConfigSocketService().connect(
        url: '${dotenv.env['API_SOCKET_URL']}',
        roomId: widget.plant.id,
      );
      IotConfigSocketService().sendIotConfigUpdate(iotConfig);
      IotConfigSocketService().disconnect();

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fejl ved opdatering: $e')));
    }
  }

  /// Dispose of the controllers and disconnect from the socket service
  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    descController.dispose();
    potVolumeController.dispose();
    requiredWaterController.dispose();
    allowedDryPeriodController.dispose();
    dateTimeController.dispose();
    moistureController.dispose();
    moistureMinValController.dispose();
    waterLevelController.dispose();
    lastWateredController.dispose();

    MetricsSocketService().disconnect();
    super.dispose();
  }

  /// Build the UI for the plant detail page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.plant.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlantForm(
                nameController: nameController,
                typeController: typeController,
                descController: descController,
                potVolumeController: potVolumeController,
                requiredWaterController: requiredWaterController,
                allowedDryPeriodController: allowedDryPeriodController,
                moistureMinValController: moistureMinValController,
              ),
              const SizedBox(height: 32),
              const Text(
                'Metrics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              PlantTextfields(
                controller: dateTimeController,
                label: 'Date/Time ',
                readOnly: true,
              ),
              PlantTextfields(
                controller: moistureController,
                label: 'Moisture (%)',
                readOnly: true,
              ),
              PlantTextfields(
                controller: waterLevelController,
                label: 'Water Level',
                readOnly: true,
              ),
              PlantTextfields(
                controller: lastWateredController,
                label: 'Last Watered',
                readOnly: true,
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
      ),
    );
  }
}
