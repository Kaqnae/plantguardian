class IotConfigModel {
  final String customPlantId;
  final double moistureMinVal;
  final double allowedDryPeriod;
  final double requiredWater;

  IotConfigModel({
    required this.customPlantId,
    required this.moistureMinVal,
    required this.allowedDryPeriod,
    required this.requiredWater,
  });

  Map<String, dynamic> toJson() {
    return {
      'customPlantId': customPlantId,
      'moistureMinVal': moistureMinVal,
      'allowedDryPeriod': allowedDryPeriod,
      'requiredWater': requiredWater,
    };
  }
}
