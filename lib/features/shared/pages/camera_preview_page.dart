import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

/// Page for previewing the camera and taking a picture.
class CameraPreviewPage extends StatefulWidget {
  const CameraPreviewPage({super.key});

  @override
  State<CameraPreviewPage> createState() => _CameraPreviewPageState();
}

/// State class for CameraPreviewPage.
/// Handles camera initialization, permissions, and taking pictures.
class _CameraPreviewPageState extends State<CameraPreviewPage> {
  // Controller for the camera
  late CameraController _controller;

  // Whether the camera is initialized and ready
  bool _isInitialized = false;

  /// Initializes permissions and the camera when the widget is created.
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  /// Checks for camera and storage permissions.
  /// Initializes the camera if permissions are granted, otherwise shows a snackbar and pops the page.
  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      _initCamera();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and storage permissions are required.'),
        ),
      );
      Navigator.pop(context);
    }
  }

  /// Initializes the camera controller with the back camera.
  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _controller = CameraController(backCamera, ResolutionPreset.high);
    await _controller.initialize();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  /// Takes a picture, saves it to the gallery, and returns the image file.
  /// Shows a snackbar if saving fails.
  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized || _controller.value.isTakingPicture) {
      return;
    }

    try {
      final image = await _controller.takePicture();

      final imageBytes = await File(image.path).readAsBytes();

      final fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final saveResult = await SaverGallery.saveImage(
        imageBytes,
        fileName: fileName,
        skipIfExists: true,
      );

      if (saveResult.isSuccess) {
        if (mounted) {
          Navigator.pop(context, image);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image: ${saveResult.errorMessage}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
    }
  }

  /// Disposes the camera controller when the widget is removed from the tree.
  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Builds the camera preview UI with a capture button and close button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _isInitialized
              ? Stack(
                children: [
                  Center(child: CameraPreview(_controller)),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 60,
                        color: Colors.white,
                      ),
                      onPressed: _takePicture,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
