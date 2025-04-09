import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../utils/theme.dart';
import '../utils/mock_data.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback? onDismiss;
  
  const AlarmCard({
    Key? key,
    required this.alarm,
    this.onDismiss,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y H:mm');
    final timestamp = DateTime.parse(alarm.timestamp);
    final formattedDate = dateFormat.format(timestamp);
    
    // Get entity info (hive or gateway)
    String entityInfo = '';
    if (alarm.hiveId != null) {
      final hive = MockData.getHiveById(alarm.hiveId!);
      if (hive != null) {
        entityInfo = 'Hive: ${hive.name}';
      }
    } else if (alarm.gatewayId != null) {
      final gateway = MockData.gateways.firstWhere(
        (g) => g.id == alarm.gatewayId,
        orElse: () => MockData.gateways.first,
      );
      entityInfo = 'Gateway: ${gateway.name}';
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.getSeverityColor(alarm.severity).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.getSeverityColor(alarm.severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    alarm.severity.toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.getSeverityColor(alarm.severity),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alarm.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (entityInfo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entityInfo,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              alarm.description,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Timestamp: $formattedDate',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (onDismiss != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onDismiss,
                  child: const Text('Dismiss'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}