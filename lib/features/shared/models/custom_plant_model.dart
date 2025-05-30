import 'package:plantguardian/features/shared/models/generic_plant_model.dart';
import 'package:plantguardian/features/shared/models/metrics_model.dart';

class CustomPlantModel {
  final String? userId;
  final String id;
  final String name;
  final String imageUrl;
  final int potVolume;
  final int requiredWater;
  final GenericPlantModel genericPlantModel;
  final MetricsModel? metricsModel;

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

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      '_id': id,
      'name': name,
      'imageUrl': imageUrl,
      'potVolume': potVolume,
      'requiredWater': requiredWater,
      'genericPlant': genericPlantModel.toJson(),
      'metrics': metricsModel?.toJson(),
    };
  }

  /*
  factory CustomPlantModel.fromJson(Map<String, dynamic> json) {
    return CustomPlantModel(
      id: (json['_id']) ?? 'null'.toString(),
      name: (json['name'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      potVolume:
          json['potVolume'] is int
              ? json['potVolume']
              : int.tryParse(json['potVolume']?.toString() ?? '') ?? 0,
      requiredWater:
          json['requiredWater'] is int
              ? json['requiredWater']
              : int.tryParse(json['requiredWater']?.toString() ?? '') ?? 0,
      genericPlantModel: GenericPlantModel.fromJson(json['genericPlant'] ?? {}),
    );
  }
  */
  factory CustomPlantModel.fromJson(Map<String, dynamic> json) {
    final genericPlantField = json['genericPlant'];
    GenericPlantModel? genericPlantModel;

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

    MetricsModel? metricsModel;
    if (json['metrics'] != null && json['metrics'] is Map<String, dynamic>) {
      metricsModel = MetricsModel.fromJson(json['metrics']);
    } else {
      metricsModel = null;
    }

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
