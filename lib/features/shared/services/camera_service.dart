import 'package:camera/camera.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();

  factory CameraService() => _instance;

  CameraService._internal();

  CameraController? _cameraController;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _isInitialized = true;
      print('Camera initialized successfully.');
    } catch (e) {
      print('Camera initialization failed: $e');
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    if (!_isInitialized || _cameraController == null) return null;
    if (_cameraController!.value.isTakingPicture) return null;

    try {
      return await _cameraController!.takePicture();
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  CameraController? get controller => _cameraController;

  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
    _isInitialized = false;
  }
}
