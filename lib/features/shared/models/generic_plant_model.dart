class GenericPlantModel {
  final String id;
  final String latinName;
  final String desc;
  final String category;
  final int moistureMin;
  final int allowedDryPeriod;
  final int tempMin;
  final int tempMax;

  GenericPlantModel({
    required this.id,
    required this.latinName,
    required this.desc,
    required this.category,
    required this.moistureMin,
    required this.allowedDryPeriod,
    required this.tempMin,
    required this.tempMax,
  });

  factory GenericPlantModel.fromJson(Map<String, dynamic> json) {
    return GenericPlantModel(
      id: (json['_id'] ?? '').toString(),
      latinName: (json['latinName'] ?? '').toString(),
      desc: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      moistureMin:
          json['moistureMinVal'] is int
              ? json['moistureMinVal']
              : int.tryParse(json['moistureMinVal']?.toString() ?? '') ?? 0,
      allowedDryPeriod:
          json['allowedDryPeriod'] is int
              ? json['allowedDryPeriod']
              : int.tryParse(json['allowedDryPeriod']?.toString() ?? '') ?? 0,
      tempMin:
          json['tempMinVal'] is int
              ? json['tempMinVal']
              : int.tryParse(json['tempMinVal']?.toString() ?? '') ?? 0,
      tempMax:
          json['tempMaxVal'] is int
              ? json['tempMaxVal']
              : int.tryParse(json['tempMaxVal']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latinName': latinName,
      'description': desc,
      'category': category,
      'moistureMinVal': moistureMin,
      'allowedDryPeriod': allowedDryPeriod,
      'tempMinVal': tempMin,
      'tempMaxVal': tempMax,
    };
  }
}
