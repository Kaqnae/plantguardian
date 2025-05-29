class GenericPlantModel {
  final String id;
  final String latinName;
  final String description;
  final String category;
  final int moistureMinVal;
  final int allowedDryPeriod;
  final int tempMinVal;
  final int tempMaxVal;

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
