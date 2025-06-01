/// Model class representing the IoT configuration for a custom plant.
class IotConfigModel {
  /// The ID of the custom plant this config belongs to.
  final String customPlantId;

  /// The minimum moisture value required for the plant.
  final double moistureMinVal;

  /// The allowed dry period (in days) for the plant.
  final double allowedDryPeriod;

  /// The required amount of water for the plant.
  final double requiredWater;

  /// Constructor for creating an IoT config model.
  IotConfigModel({
    required this.customPlantId,
    required this.moistureMinVal,
    required this.allowedDryPeriod,
    required this.requiredWater,
  });

  /// Converts the IoT config model to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'customPlantId': customPlantId,
      'moistureMinVal': moistureMinVal,
      'allowedDryPeriod': allowedDryPeriod,
      'requiredWater': requiredWater,
    };
  }
}
