import '../models/models.dart';

class MockData {
  // Mock locations
  static List<String> locations = ["Mount Everest", "Dolina 1", "Dolina 2"];

  // Mock gateways
  static List<Gateway> gateways = [
    Gateway(
      id: 1,
      name: "Gateway 1",
      location: "Mount Everest",
      batteryLevel: 87.5,
      lastUpdate: "2025-04-08T08:30:00Z",
      temperature: 23.5,
      hiveCount: 5,
    ),
    Gateway(
      id: 2,
      name: "Gateway 2",
      location: "Dolina 1",
      batteryLevel: 92.0,
      lastUpdate: "2025-04-08T09:15:00Z",
      temperature: 22.8,
      hiveCount: 3,
    ),
    Gateway(
      id: 3,
      name: "Gateway 3",
      location: "Dolina 2",
      batteryLevel: 64.3,
      lastUpdate: "2025-04-08T07:45:00Z",
      temperature: 24.2,
      hiveCount: 4,
    ),
    Gateway(
      id: 4,
      name: "Gateway 4",
      location: "benguerir",
      batteryLevel: 64.3,
      lastUpdate: "2025-04-08T07:45:00Z",
      temperature: 24.2,
      hiveCount: 4,
    ),
  ];

  // Mock hives
  static List<Hive> hives = [
    // Mount Everest hives
    Hive(
      id: 1,
      name: "Hive 1",
      location: "Mount Everest",
      gatewayId: 1,
      isCustomName: false,
      status: "strong",
      weight: 42.5,
      weightChange: 0.3,
      minWeight: 40.2,
      maxWeight: 43.1,
      temperature: 32.4,
      minTemperature: 30.0,
      maxTemperature: 34.5,
      humidity: 68.2,
      minHumidity: 65.0,
      maxHumidity: 75.0,
      lastUpdate: "2025-04-08T08:25:00Z",
    ),
    Hive(
      id: 2,
      name: "Hive 2",
      location: "Mount Everest",
      gatewayId: 1,
      isCustomName: false,
      status: "improving",
      weight: 38.7,
      weightChange: 0.5,
      minWeight: 36.1,
      maxWeight: 39.0,
      temperature: 31.9,
      minTemperature: 28.5,
      maxTemperature: 33.0,
      humidity: 70.5,
      minHumidity: 67.0,
      maxHumidity: 74.2,
      lastUpdate: "2025-04-08T08:20:00Z",
    ),
    Hive(
      id: 3,
      name: "Queen's Palace",
      location: "Mount Everest",
      gatewayId: 1,
      isCustomName: true,
      status: "declining",
      weight: 35.2,
      weightChange: -0.7,
      minWeight: 35.0,
      maxWeight: 41.3,
      temperature: 30.8,
      minTemperature: 29.0,
      maxTemperature: 33.5,
      humidity: 65.7,
      minHumidity: 62.0,
      maxHumidity: 71.0,
      lastUpdate: "2025-04-08T08:15:00Z",
    ),
    Hive(
      id: 4,
      name: "Honey Heaven",
      location: "Mount Everest",
      gatewayId: 1,
      isCustomName: true,
      status: "wintering",
      weight: 40.1,
      weightChange: -0.2,
      minWeight: 39.8,
      maxWeight: 45.2,
      temperature: 28.5,
      minTemperature: 27.0,
      maxTemperature: 32.0,
      humidity: 72.3,
      minHumidity: 68.5,
      maxHumidity: 76.0,
      lastUpdate: "2025-04-08T08:10:00Z",
    ),
    Hive(
      id: 5,
      name: "Hive 5",
      location: "Mount Everest",
      gatewayId: 1,
      isCustomName: false,
      status: "danger",
      weight: 33.6,
      weightChange: -1.3,
      minWeight: 33.5,
      maxWeight: 43.0,
      temperature: 35.8,
      minTemperature: 28.0,
      maxTemperature: 36.0,
      humidity: 58.9,
      minHumidity: 58.0,
      maxHumidity: 73.5,
      lastUpdate: "2025-04-08T08:05:00Z",
    ),

    // Dolina 1 hives
    Hive(
      id: 6,
      name: "Hive 6",
      location: "Dolina 1",
      gatewayId: 2,
      isCustomName: false,
      status: "strong",
      weight: 44.7,
      weightChange: 0.4,
      minWeight: 41.3,
      maxWeight: 45.0,
      temperature: 32.1,
      minTemperature: 30.5,
      maxTemperature: 34.0,
      humidity: 69.8,
      minHumidity: 66.0,
      maxHumidity: 75.5,
      lastUpdate: "2025-04-08T09:10:00Z",
    ),
    Hive(
      id: 7,
      name: "Busy Bees",
      location: "Dolina 1",
      gatewayId: 2,
      isCustomName: true,
      status: "strong",
      weight: 43.2,
      weightChange: 0.6,
      minWeight: 40.5,
      maxWeight: 44.0,
      temperature: 31.7,
      minTemperature: 29.5,
      maxTemperature: 33.5,
      humidity: 71.2,
      minHumidity: 68.0,
      maxHumidity: 74.8,
      lastUpdate: "2025-04-08T09:05:00Z",
    ),
    Hive(
      id: 8,
      name: "Hive 8",
      location: "Dolina 1",
      gatewayId: 2,
      isCustomName: false,
      status: "improving",
      weight: 39.8,
      weightChange: 0.8,
      minWeight: 36.9,
      maxWeight: 40.2,
      temperature: 30.5,
      minTemperature: 28.0,
      maxTemperature: 32.5,
      humidity: 68.5,
      minHumidity: 65.5,
      maxHumidity: 72.0,
      lastUpdate: "2025-04-08T09:00:00Z",
    ),

    // Dolina 2 hives
    Hive(
      id: 9,
      name: "Pollen Palace",
      location: "Dolina 2",
      gatewayId: 3,
      isCustomName: true,
      status: "strong",
      weight: 45.3,
      weightChange: 0.7,
      minWeight: 42.1,
      maxWeight: 46.0,
      temperature: 33.0,
      minTemperature: 31.0,
      maxTemperature: 35.0,
      humidity: 70.1,
      minHumidity: 67.5,
      maxHumidity: 76.0,
      lastUpdate: "2025-04-08T07:40:00Z",
    ),
    Hive(
      id: 10,
      name: "Hive 10",
      location: "Dolina 2",
      gatewayId: 3,
      isCustomName: false,
      status: "declining",
      weight: 36.8,
      weightChange: -0.5,
      minWeight: 36.5,
      maxWeight: 42.7,
      temperature: 29.6,
      minTemperature: 28.0,
      maxTemperature: 33.0,
      humidity: 66.3,
      minHumidity: 63.0,
      maxHumidity: 72.5,
      lastUpdate: "2025-04-08T07:35:00Z",
    ),
    Hive(
      id: 11,
      name: "Sweet Spot",
      location: "Dolina 2",
      gatewayId: 3,
      isCustomName: true,
      status: "improving",
      weight: 41.4,
      weightChange: 0.3,
      minWeight: 38.7,
      maxWeight: 42.0,
      temperature: 31.2,
      minTemperature: 29.0,
      maxTemperature: 33.0,
      humidity: 69.5,
      minHumidity: 67.0,
      maxHumidity: 73.0,
      lastUpdate: "2025-04-08T07:30:00Z",
    ),
    Hive(
      id: 12,
      name: "Hive 12",
      location: "Dolina 2",
      gatewayId: 3,
      isCustomName: false,
      status: "wintering",
      weight: 39.5,
      weightChange: -0.1,
      minWeight: 39.4,
      maxWeight: 44.8,
      temperature: 27.9,
      minTemperature: 26.5,
      maxTemperature: 31.5,
      humidity: 73.7,
      minHumidity: 69.0,
      maxHumidity: 77.0,
      lastUpdate: "2025-04-08T07:25:00Z",
    ),
  ];

  // Mock alarms
  static List<Alarm> alarms = [
    Alarm(
      id: 1,
      title: "High temperature detected",
      description: "Temperature has exceeded the maximum threshold of 35°C",
      severity: "high",
      hiveId: 5,
      timestamp: "2025-04-08T08:00:00Z",
      canDismiss: true,
    ),
    Alarm(
      id: 2,
      title: "Weight decreasing",
      description: "Hive weight has been decreasing for 3 consecutive days",
      severity: "medium",
      hiveId: 3,
      timestamp: "2025-04-08T07:45:00Z",
      canDismiss: true,
    ),
    Alarm(
      id: 3,
      title: "Low battery warning",
      description: "Gateway battery level is below 65%",
      severity: "medium",
      gatewayId: 3,
      timestamp: "2025-04-08T07:30:00Z",
      canDismiss: false,
    ),
    Alarm(
      id: 4,
      title: "Gateway offline",
      description: "Gateway has been offline for 15 minutes",
      severity: "high",
      gatewayId: 3,
      timestamp: "2025-04-07T22:15:00Z",
      canDismiss: true,
    ),
    Alarm(
      id: 5,
      title: "Low humidity detected",
      description: "Humidity has fallen below the minimum threshold of 60%",
      severity: "low",
      hiveId: 5,
      timestamp: "2025-04-07T18:20:00Z",
      canDismiss: true,
    ),
    Alarm(
      id: 6,
      title: "Update complete",
      description:
          "Firmware update has been successfully installed on the gateway",
      severity: "info",
      gatewayId: 1,
      timestamp: "2025-04-07T15:45:00Z",
      canDismiss: true,
    ),
    Alarm(
      id: 7,
      title: "New hive detected",
      description:
          "Gateway has detected a new hive in range. Please configure it.",
      severity: "info",
      gatewayId: 2,
      timestamp: "2025-04-07T14:30:00Z",
      canDismiss: true,
    ),
    Alarm(
      id: 8,
      title: "Hive inspection reminder",
      description:
          "It's been 14 days since your last recorded inspection of this hive",
      severity: "low",
      hiveId: 6,
      timestamp: "2025-04-07T09:15:00Z",
      canDismiss: true,
    ),
    Alarm(
      id: 9,
      title: "Weight anomaly detected",
      description:
          "Sudden weight increase detected. Possible swarm or interference.",
      severity: "medium",
      hiveId: 8,
      timestamp: "2025-04-07T08:05:00Z",
      canDismiss: false,
    ),
    Alarm(
      id: 10,
      title: "Temperature fluctuation",
      description:
          "Unusual temperature pattern detected over the last 24 hours",
      severity: "low",
      hiveId: 10,
      timestamp: "2025-04-06T23:50:00Z",
      canDismiss: true,
    ),
  ];

  // Helper methods
  static Hive? getHiveById(int id) {
    try {
      return hives.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Hive> getHivesByLocation(String location) {
    return hives.where((h) => h.location == location).toList();
  }

  static List<Hive> getHivesByGateway(int gatewayId) {
    return hives.where((h) => h.gatewayId == gatewayId).toList();
  }

  static List<Gateway> getGatewaysByLocation(String location) {
    return gateways.where((g) => g.location == location).toList();
  }

  static List<Alarm> getAlarmsByLocation(String location) {
    List<Alarm> result = [];

    // Get all hives in this location
    final locationHives = getHivesByLocation(location);

    // Get alarms for these hives
    for (var alarm in alarms) {
      if (alarm.hiveId != null &&
          locationHives.any((h) => h.id == alarm.hiveId)) {
        result.add(alarm);
      }
    }

    // Get gateways in this location
    final locationGateways = getGatewaysByLocation(location);

    // Get alarms for these gateways
    for (var alarm in alarms) {
      if (alarm.gatewayId != null &&
          locationGateways.any((g) => g.id == alarm.gatewayId)) {
        result.add(alarm);
      }
    }

    return result;
  }

  static List<Alarm> getAlarmsByHive(int hiveId) {
    return alarms.where((a) => a.hiveId == hiveId).toList();
  }

  static List<Alarm> getAlarmsByGateway(int gatewayId) {
    return alarms.where((a) => a.gatewayId == gatewayId).toList();
  }
}
