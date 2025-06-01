/// Model class representing a generic plant type.
class GenericPlantModel {
  /// The unique ID of the generic plant.
  final String id;

  /// The Latin name of the plant.
  final String latinName;

  /// The description of the plant.
  final String description;

  /// The category of the plant (e.g., succulent, herb, etc.).
  final String category;

  /// The minimum moisture value required for the plant.
  final int moistureMinVal;

  /// The allowed dry period (in days) for the plant.
  final int allowedDryPeriod;

  /// The minimum temperature the plant can tolerate.
  final int tempMinVal;

  /// The maximum temperature the plant can tolerate.
  final int tempMaxVal;

  /// Constructor for creating a GenericPlantModel.
  GenericPlantModel({
    required this.id,
    required this.latinName,
    required this.description,
    required this.category,
    required this.moistureMinVal,
    required this.allowedDryPeriod,
    required this.tempMinVal,
    required this.tempMaxVal,
  });

  /// Creates a GenericPlantModel from a JSON map.
  factory GenericPlantModel.fromJson(Map<String, dynamic> json) {
    return GenericPlantModel(
      id: (json['_id'] ?? '').toString(),
      latinName: (json['latinName'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      moistureMinVal:
          json['moistureMinVal'] is int
              ? json['moistureMinVal']
              : int.tryParse(json['moistureMinVal']?.toString() ?? '') ?? 0,
      allowedDryPeriod:
          json['allowedDryPeriod'] is int
              ? json['allowedDryPeriod']
              : int.tryParse(json['allowedDryPeriod']?.toString() ?? '') ?? 0,
      tempMinVal:
          json['tempMinVal'] is int
              ? json['tempMinVal']
              : int.tryParse(json['tempMinVal']?.toString() ?? '') ?? 0,
      tempMaxVal:
          json['tempMaxVal'] is int
              ? json['tempMaxVal']
              : int.tryParse(json['tempMaxVal']?.toString() ?? '') ?? 0,
    );
  }

  /// Converts the generic plant model to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latinName': latinName,
      'description': description,
      'category': category,
      'moistureMinVal': moistureMinVal,
      'allowedDryPeriod': allowedDryPeriod,
      'tempMinVal': tempMinVal,
      'tempMaxVal': tempMaxVal,
    };
  }
}
