import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantguardian/features/add_plant/data/fetch_generic_plants_api.dart';
import 'package:plantguardian/features/add_plant/data/post_custom_plant_api.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/models/generic_plant_model.dart';
import 'package:plantguardian/features/shared/widgets/plant_form.dart';
import 'package:plantguardian/features/shared/pages/camera_preview_page.dart';
import 'package:image_picker/image_picker.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final descController = TextEditingController();
  final potVolumeController = TextEditingController();
  final requiredWaterController = TextEditingController();
  XFile? _image;

  late Future<List<GenericPlantModel>> futurePlants;
  GenericPlantModel? selectedPlant;

  Future<void> _takePicture() async {
    final image = await Navigator.push<XFile?>(
      context,
      MaterialPageRoute(builder: (_) => const CameraPreviewPage()),
    );

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    futurePlants = FetchGenericPlantsApi().fetchPlants();
    futurePlants.then((plants) {
      if (plants.isNotEmpty) {
        setState(() {
          selectedPlant = plants[0];
          updateTextFields(selectedPlant!);
        });
      }
    });
  }

  void updateTextFields(GenericPlantModel plant) {
    nameController.text = plant.latinName;
    typeController.text = plant.category;
    descController.text = plant.description;
  }

  Future<void> saveCustomPlant() async {
    if (selectedPlant == null) {
      return;
    }

    final customPlant = CustomPlantModel(
      id: '',
      name: nameController.text,
      imageUrl: _image?.path ?? '',
      potVolume: int.tryParse(potVolumeController.text) ?? 0,
      requiredWater: int.tryParse(requiredWaterController.text) ?? 0,
      genericPlantModel: selectedPlant!,
    );

    try {
      await PostCustomPlantApi().createCustomPlant(customPlant);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fejl ved oprettelse af plante: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              Image.file(
                File(_image!.path),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
            FutureBuilder<List<GenericPlantModel>>(
              future: futurePlants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No plants available');
                } else {
                  List<GenericPlantModel> plants = snapshot.data!;
                  return Column(
                    children: [
                      DropdownButton<GenericPlantModel>(
                        value: selectedPlant,
                        onChanged: (GenericPlantModel? newPlant) {
                          setState(() {
                            selectedPlant = newPlant;
                            updateTextFields(newPlant!);
                          });
                        },
                        items:
                            plants.map((GenericPlantModel plant) {
                              return DropdownMenuItem<GenericPlantModel>(
                                value: plant,
                                child: Text(plant.latinName),
                              );
                            }).toList(),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            PlantForm(
              nameController: nameController,
              typeController: typeController,
              descController: descController,
              potVolumeController: potVolumeController,
              requiredWaterController: requiredWaterController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveCustomPlant,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePicture,
              child: const Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
