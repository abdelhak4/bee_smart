import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/models.dart';
import '../providers/apiary_provider.dart';
import '../utils/mock_data.dart';
import '../utils/theme.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/location_tabs.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiaryProvider = Provider.of<ApiaryProvider>(context);
    final activeLocation = apiaryProvider.activeLocation;

    // Get gateways for this location
    final gateways = MockData.getGatewaysByLocation(activeLocation);

    // Get hives for this location
    final hives = MockData.getHivesByLocation(activeLocation);

    // Get alarms for this location
    final alarms = MockData.getAlarmsByLocation(activeLocation);

    // Count high priority alarms
    final highPriorityAlarms = alarms.where((a) => a.severity == 'high').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/alarms');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location tabs
          LocationTabs(
            locations: apiaryProvider.locations,
            activeLocation: activeLocation,
            onLocationChanged: apiaryProvider.setActiveLocation,
          ),

          // Dashboard content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // In a real app, this would refresh data from the server
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Summary cards
                  _buildSummarySection(
                    context,
                    highPriorityAlarms,
                    hives.length,
                    gateways.length,
                  ),

                  const SizedBox(height: 24),

                  // Gateways section
                  _buildSectionHeader('Gateways', gateways.length),
                  const SizedBox(height: 12),
                  ...gateways.map(
                    (gateway) => _buildGatewayCard(context, gateway),
                  ),

                  const SizedBox(height: 24),

                  // Hives section
                  _buildSectionHeader('Hives', hives.length),
                  const SizedBox(height: 12),

                  // Grid of hive status indicators
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.45,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: hives.length,
                    itemBuilder: (context, index) {
                      return _buildHiveStatusCard(context, hives[index]);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Recent activity section
                  _buildSectionHeader('Recent Activity', alarms.length),
                  const SizedBox(height: 12),

                  // List of recent alarms
                  alarms.isEmpty
                      ? _buildEmptyState('No recent activity')
                      : Column(
                        children:
                            alarms
                                .take(3)
                                .map(
                                  (alarm) => _buildActivityItem(context, alarm),
                                )
                                .toList(),
                      ),

                  if (alarms.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/alarms');
                        },
                        child: const Text('View all activity'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        activeTab: 'dashboard',
        onTabChanged: (tab) {
          // Handle navigation
          if (tab != 'dashboard') {
            Navigator.of(context).pushReplacementNamed('/$tab');
          }
        },
      ),
    );
  }

  Widget _buildSummarySection(
    BuildContext context,
    int highPriorityAlarms,
    int hiveCount,
    int gatewayCount,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context,
            'Alerts',
            highPriorityAlarms.toString(),
            highPriorityAlarms > 0 ? Colors.red : Colors.green,
            Icons.warning_amber_rounded,
            () {
              Navigator.pushNamed(context, '/alarms');
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            context,
            'Hives',
            hiveCount.toString(),
            AppColors.primary,
            Icons.hexagon_outlined,
            () {
              Navigator.pushNamed(context, '/hives');
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            context,
            'Gateways',
            gatewayCount.toString(),
            AppColors.secondary,
            Icons.router_outlined,
            () {
              // Navigate to gateways screen (not implemented yet)
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGatewayCard(BuildContext context, Gateway gateway) {
    final hives = MockData.getHivesByGateway(gateway.id);
    final strongHives =
        hives
            .where((h) => h.status == 'strong' || h.status == 'improving')
            .length;

    // Battery level color
    Color batteryColor;
    if (gateway.batteryLevel > 70) {
      batteryColor = Colors.green;
    } else if (gateway.batteryLevel > 30) {
      batteryColor = Colors.orange;
    } else {
      batteryColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.router, color: AppColors.secondary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gateway.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${gateway.hiveCount} hives connected',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 20.0,
                  lineWidth: 4.0,
                  percent: gateway.batteryLevel / 100,
                  center: Text(
                    '${gateway.batteryLevel.toInt()}%',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  progressColor: batteryColor,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildGatewayMetric(
                  'Temperature',
                  '${gateway.temperature.toStringAsFixed(1)}°C',
                  Icons.thermostat_outlined,
                ),
                _buildGatewayMetric(
                  'Strong Hives',
                  '$strongHives/${hives.length}',
                  Icons.trending_up,
                ),
                _buildGatewayMetric(
                  'Last Update',
                  _getFormattedTime(gateway.lastUpdate),
                  Icons.access_time,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGatewayMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHiveStatusCard(BuildContext context, Hive hive) {
    // Status color
    Color statusColor;
    switch (hive.status) {
      case 'strong':
        statusColor = Colors.green;
        break;
      case 'improving':
        statusColor = Colors.lightGreen;
        break;
      case 'declining':
        statusColor = Colors.orange;
        break;
      case 'wintering':
        statusColor = Colors.blue;
        break;
      case 'danger':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/hive-detail', arguments: hive.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hive.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHiveMetric(
                    '${hive.temperature.toStringAsFixed(1)}°C',
                    Icons.thermostat_outlined,
                  ),
                  _buildHiveMetric(
                    '${hive.humidity.toStringAsFixed(1)}%',
                    Icons.opacity_outlined,
                  ),
                  _buildHiveMetric(
                    '${hive.weight.toStringAsFixed(1)}kg',
                    Icons.monitor_weight_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    hive.weightChange >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 14,
                    color: hive.weightChange >= 0 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hive.weightChange >= 0
                        ? '+${hive.weightChange.toStringAsFixed(1)}kg'
                        : '${hive.weightChange.toStringAsFixed(1)}kg',
                    style: TextStyle(
                      fontSize: 12,
                      color: hive.weightChange >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHiveMetric(String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActivityItem(BuildContext context, Alarm alarm) {
    // Severity color
    final severityColor = AppTheme.getSeverityColor(alarm.severity);

    // Entity info (hive or gateway)
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
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: severityColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getAlarmIcon(alarm.severity),
                color: severityColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alarm.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (entityInfo.isNotEmpty)
                    Text(
                      entityInfo,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    _getFormattedTime(alarm.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(message, style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  IconData _getAlarmIcon(String severity) {
    switch (severity) {
      case 'high':
        return Icons.warning_amber_rounded;
      case 'medium':
        return Icons.warning_outlined;
      case 'low':
        return Icons.info_outline;
      case 'info':
        return Icons.notifications_none;
      default:
        return Icons.notifications_none;
    }
  }

  String _getFormattedTime(String timestamp) {
    final now = DateTime.now();
    final time = DateTime.parse(timestamp);
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
