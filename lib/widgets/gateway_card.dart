import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../utils/theme.dart';

class GatewayCard extends StatelessWidget {
  final Gateway gateway;
  final VoidCallback? onTap;

  const GatewayCard({
    Key? key,
    required this.gateway,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y H:mm');
    final lastUpdateDate = DateTime.parse(gateway.lastUpdate);
    final formattedDate = dateFormat.format(lastUpdateDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    gateway.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildBatteryIndicator(gateway.batteryLevel.toInt()),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.thermostat_outlined,
                'Temperature',
                '${gateway.temperature.toStringAsFixed(1)}°C',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.hive,
                'Hives',
                '${gateway.hiveCount}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Location',
                gateway.location,
              ),
              const SizedBox(height: 12),
              Text(
                'Last update: $formattedDate',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryIndicator(int batteryLevel) {
    Color batteryColor = Colors.green;
    if (batteryLevel < 20) {
      batteryColor = Colors.red;
    } else if (batteryLevel < 50) {
      batteryColor = Colors.orange;
    }

    return Row(
      children: [
        Icon(
          batteryLevel < 15
              ? Icons.battery_alert
              : batteryLevel < 30
                  ? Icons.battery_1_bar
                  : batteryLevel < 50
                      ? Icons.battery_2_bar
                      : batteryLevel < 75
                          ? Icons.battery_3_bar
                          : Icons.battery_full,
          color: batteryColor,
        ),
        const SizedBox(width: 4),
        Text(
          '$batteryLevel%',
          style: TextStyle(
            color: batteryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}