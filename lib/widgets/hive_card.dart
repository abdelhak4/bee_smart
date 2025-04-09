import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../utils/theme.dart';
import 'status_indicator.dart';

class HiveCard extends StatelessWidget {
  final Hive hive;
  final VoidCallback? onTap;

  const HiveCard({
    Key? key,
    required this.hive,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y H:mm');
    final lastUpdateDate = DateTime.parse(hive.lastUpdate);
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
                    hive.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StatusIndicator(status: hive.status),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.thermostat_outlined,
                '${hive.temperature.toStringAsFixed(1)}°C',
                '${hive.minTemperature.toStringAsFixed(1)}°C - ${hive.maxTemperature.toStringAsFixed(1)}°C',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.opacity_outlined,
                '${hive.humidity.toStringAsFixed(1)}%',
                '${hive.minHumidity.toStringAsFixed(1)}% - ${hive.maxHumidity.toStringAsFixed(1)}%',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.monitor_weight_outlined,
                '${hive.weight.toStringAsFixed(1)}kg',
                hive.weightChange >= 0
                    ? '+${hive.weightChange.toStringAsFixed(1)}kg'
                    : '${hive.weightChange.toStringAsFixed(1)}kg',
                hive.weightChange >= 0 ? Colors.green : Colors.red,
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

  Widget _buildInfoRow(IconData icon, String value, String subValue, [Color? subValueColor]) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Text(
          subValue,
          style: TextStyle(
            fontSize: 12,
            color: subValueColor ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}