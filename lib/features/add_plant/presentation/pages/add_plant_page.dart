import 'dart:io';
import 'package:flutter/material.dart';
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
  final lastWateredController = TextEditingController();
  XFile? _image;

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
            PlantForm(
              nameController: nameController,
              typeController: typeController,
              descController: descController,
              lastWateredController: lastWateredController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newPlant = {
                  'name': nameController.text,
                  'type': typeController.text,
                  'description': descController.text,
                  'image': _image?.path,
                };

                Navigator.pop(context);
              },
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
