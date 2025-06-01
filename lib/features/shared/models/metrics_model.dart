/// Model class representing a set of metrics for a custom plant.
class MetricsModel {
  /// The ID of the custom plant these metrics belong to.
  final String customPlantId;

  /// The timestamp when the metric was recorded.
  final DateTime dateTimeStamp;

  /// The measured moisture level of the plant.
  final double moistureLevel;

  /// The water level status (as a string).
  final String waterLevel;

  /// The last time the plant was watered.
  final DateTime lastWatered;

  /// Constructor for creating a MetricsModel.
  MetricsModel({
    required this.customPlantId,
    required this.dateTimeStamp,
    required this.moistureLevel,
    required this.waterLevel,
    required this.lastWatered,
  });

  /// Converts the metrics model to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'customPlantId': customPlantId,
      'dateTimeStamp': dateTimeStamp.toIso8601String(),
      'moistureLevel': moistureLevel,
      'waterLevel': waterLevel,
      'lastWatered': lastWatered.toIso8601String(),
    };
  }

  /// Creates a MetricsModel from a JSON map.
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
