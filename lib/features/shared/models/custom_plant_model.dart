import 'package:plantguardian/features/shared/models/generic_plant_model.dart';
import 'package:plantguardian/features/shared/models/metrics_model.dart';

/// Model class representing a custom plant created by a user.
class CustomPlantModel {
  /// The ID of the user who owns this plant.
  final String? userId;

  /// The unique ID of the custom plant.
  final String id;

  /// The display name of the plant.
  final String name;

  /// The image URL or file path for the plant.
  final String imageUrl;

  /// The volume of the pot in milliliters.
  final int potVolume;

  /// The required amount of water for the plant.
  final int requiredWater;

  /// The generic plant model this custom plant is based on.
  final GenericPlantModel genericPlantModel;

  /// The latest metrics for this plant, if available.
  final MetricsModel? metricsModel;

  /// Constructor for creating a CustomPlantModel.
  CustomPlantModel({
    this.userId,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.potVolume,
    required this.requiredWater,
    required this.genericPlantModel,
    this.metricsModel,
  });

  /// Converts the custom plant model to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      '_id': id,
      'name': name,
      'imageUrl': imageUrl,
      'potVolume': potVolume,
      'requiredWater': requiredWater,
      'genericPlant': genericPlantModel.toJson(),
      'latestMetric': metricsModel?.toJson(),
    };
  }

  /// Creates a CustomPlantModel from a JSON map.
  factory CustomPlantModel.fromJson(Map<String, dynamic> json) {
    final genericPlantField = json['genericPlant'];
    GenericPlantModel? genericPlantModel;

    // Handle both object and string representations for genericPlant
    if (genericPlantField is Map<String, dynamic>) {
      genericPlantModel = GenericPlantModel.fromJson(genericPlantField);
    } else if (genericPlantField is String) {
      genericPlantModel = GenericPlantModel(
        id: genericPlantField,
        latinName: '',
        description: '',
        category: '',
        moistureMinVal: 0,
        allowedDryPeriod: 0,
        tempMinVal: 0,
        tempMaxVal: 0,
      );
    } else {
      genericPlantModel = GenericPlantModel(
        id: '',
        latinName: '',
        description: '',
        category: '',
        moistureMinVal: 0,
        allowedDryPeriod: 0,
        tempMinVal: 0,
        tempMaxVal: 0,
      );
    }

    // Parse metrics if available
    MetricsModel? metricsModel;
    if (json['latestMetric'] != null &&
        json['latestMetric'] is Map<String, dynamic>) {
      metricsModel = MetricsModel.fromJson(json['latestMetric']);
    } else {
      metricsModel = null;
    }

    // Return the constructed CustomPlantModel
    return CustomPlantModel(
      userId: json['userId'] as String?,
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      potVolume:
          (json['potVolume'] is int)
              ? json['potVolume']
              : int.tryParse(json['potVolume'].toString()) ?? 0,
      requiredWater:
          (json['requiredWater'] is int)
              ? json['requiredWater']
              : int.tryParse(json['requiredWater'].toString()) ?? 0,
      genericPlantModel: genericPlantModel,
      metricsModel: metricsModel,
    );
  }
}
