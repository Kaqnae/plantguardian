import 'package:plantguardian/features/shared/models/generic_plant_model.dart';

class CustomPlantModel {
  final String id;
  final String name;
  final String imageUrl;
  final int potVolume;
  final int requiredWater;
  final GenericPlantModel genericPlantModel;

  CustomPlantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.potVolume,
    required this.requiredWater,
    required this.genericPlantModel,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'imageUrl': imageUrl,
      'potVolume': potVolume,
      'requiredWater': requiredWater,
      'genericPlant': genericPlantModel.toJson(),
    };
  }

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
}
