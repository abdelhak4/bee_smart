// User model
class User {
  final int id;
  final String username;
  final String email;
  
  User({
    required this.id,
    required this.username,
    required this.email,
  });
}

// Gateway model
class Gateway {
  final int id;
  final String name;
  final String location;
  final double batteryLevel;
  final String lastUpdate;
  final double temperature;
  final int hiveCount;
  
  Gateway({
    required this.id,
    required this.name,
    required this.location,
    required this.batteryLevel,
    required this.lastUpdate,
    required this.temperature,
    required this.hiveCount,
  });
}

// Hive model
class Hive {
  final int id;
  final String name;
  final String location;
  final int gatewayId;
  final bool isCustomName;
  final String status;
  final double weight;
  final double weightChange;
  final double minWeight;
  final double maxWeight;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final double humidity;
  final double minHumidity;
  final double maxHumidity;
  final String lastUpdate;
  
  Hive({
    required this.id,
    required this.name,
    required this.location,
    required this.gatewayId,
    required this.isCustomName,
    required this.status,
    required this.weight,
    required this.weightChange,
    required this.minWeight,
    required this.maxWeight,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.minHumidity,
    required this.maxHumidity,
    required this.lastUpdate,
  });
}

// Alarm model
class Alarm {
  final int id;
  final String title;
  final String description;
  final String severity; // high, medium, low, info
  final int? hiveId;
  final int? gatewayId;
  final String timestamp;
  final bool canDismiss;
  
  Alarm({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    this.hiveId,
    this.gatewayId,
    required this.timestamp,
    required this.canDismiss,
  });
}