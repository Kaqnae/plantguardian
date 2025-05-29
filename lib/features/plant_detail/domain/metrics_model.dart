class MetricsModel {
  final String customPlantId;
  final DateTime dateTimeStamp;
  final double moistureLevel;
  final String waterLevel;
  final DateTime lastWatered;

  MetricsModel({
    required this.customPlantId,
    required this.dateTimeStamp,
    required this.moistureLevel,
    required this.waterLevel,
    required this.lastWatered,
  });

  factory MetricsModel.fromJson(Map<String, dynamic> json) {
    return MetricsModel(
      customPlantId: json['customPlantId'] ?? '',
      dateTimeStamp: DateTime.parse(
        json['dateTimeStamp'] ?? DateTime.now().toIso8601String(),
      ),
      moistureLevel:
          (json['moistureLevel'] is num)
              ? (json['moistureLevel'] as num).toDouble()
              : double.tryParse(json['moistureLevel']?.toString() ?? '0') ??
                  0.0,
      waterLevel: json['waterLevel'] ?? '',
      lastWatered: DateTime.parse(
        json['lastWatered'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
