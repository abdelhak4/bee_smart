import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../utils/mock_data.dart';
import '../utils/theme.dart';
import '../widgets/status_indicator.dart';

class HiveDetailScreen extends StatefulWidget {
  final int hiveId;

  const HiveDetailScreen({Key? key, required this.hiveId}) : super(key: key);

  @override
  _HiveDetailScreenState createState() => _HiveDetailScreenState();
}

class _HiveDetailScreenState extends State<HiveDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hive = MockData.getHiveById(widget.hiveId);
    
    if (hive == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hive Details')),
        body: const Center(child: Text('Hive not found')),
      );
    }

    final dateFormat = DateFormat('MMM d, y H:mm');
    final lastUpdateDate = DateTime.parse(hive.lastUpdate);
    final formattedDate = dateFormat.format(lastUpdateDate);
    
    // Get gateway
    final gateway = MockData.gateways.firstWhere(
      (g) => g.id == hive.gatewayId,
      orElse: () => MockData.gateways.first,
    );

    // Get alarms for this hive
    final hiveAlarms = MockData.getAlarmsByHive(hive.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(hive.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit hive
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Hive header with status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hive.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gateway: ${gateway.name}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: StatusIndicator(status: hive.status),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildKeyMetric(
                      'Temperature',
                      '${hive.temperature.toStringAsFixed(1)}°C',
                      Icons.thermostat_outlined,
                    ),
                    _buildKeyMetric(
                      'Humidity',
                      '${hive.humidity.toStringAsFixed(1)}%',
                      Icons.opacity_outlined,
                    ),
                    _buildKeyMetric(
                      'Weight',
                      '${hive.weight.toStringAsFixed(1)}kg',
                      Icons.monitor_weight_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Last update: $formattedDate',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Charts'),
              Tab(text: 'Alarms'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Overview tab
                _buildOverviewTab(hive),
                
                // Charts tab
                _buildChartsTab(hive),
                
                // Alarms tab
                _buildAlarmsTab(hiveAlarms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetric(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Hive hive) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailSection(
            'Temperature',
            [
              _buildDetailItem(
                'Current',
                '${hive.temperature.toStringAsFixed(1)}°C',
                Icons.thermostat_outlined,
              ),
              _buildDetailItem(
                'Min',
                '${hive.minTemperature.toStringAsFixed(1)}°C',
                Icons.arrow_downward,
              ),
              _buildDetailItem(
                'Max',
                '${hive.maxTemperature.toStringAsFixed(1)}°C',
                Icons.arrow_upward,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailSection(
            'Humidity',
            [
              _buildDetailItem(
                'Current',
                '${hive.humidity.toStringAsFixed(1)}%',
                Icons.opacity_outlined,
              ),
              _buildDetailItem(
                'Min',
                '${hive.minHumidity.toStringAsFixed(1)}%',
                Icons.arrow_downward,
              ),
              _buildDetailItem(
                'Max',
                '${hive.maxHumidity.toStringAsFixed(1)}%',
                Icons.arrow_upward,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailSection(
            'Weight',
            [
              _buildDetailItem(
                'Current',
                '${hive.weight.toStringAsFixed(1)}kg',
                Icons.monitor_weight_outlined,
              ),
              _buildDetailItem(
                'Change',
                hive.weightChange >= 0
                    ? '+${hive.weightChange.toStringAsFixed(1)}kg'
                    : '${hive.weightChange.toStringAsFixed(1)}kg',
                hive.weightChange >= 0 ? Icons.trending_up : Icons.trending_down,
                hive.weightChange >= 0 ? Colors.green : Colors.red,
              ),
              _buildDetailItem(
                'Min/Max',
                '${hive.minWeight.toStringAsFixed(1)} - ${hive.maxWeight.toStringAsFixed(1)}kg',
                Icons.compare_arrows,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildActionButton('Set Name', Icons.edit_outlined),
              _buildActionButton('Set Thresholds', Icons.tune),
              _buildActionButton('Harvest', Icons.format_list_numbered),
              _buildActionButton('Log Treatment', Icons.medication_outlined),
              _buildActionButton('Contact Support', Icons.support_agent),
              _buildActionButton('More...', Icons.more_horiz),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, [Color? iconColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColors.secondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return InkWell(
      onTap: () {
        // Action button tapped
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsTab(Hive hive) {
    // Generate some mock data for the charts
    final now = DateTime.now();
    
    // Generate temperature data for the last 7 days
    final temperatureData = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return FlSpot(
        index.toDouble(),
        hive.temperature - 2 + (4 * index / 6) + (index % 2 == 0 ? -0.5 : 0.5) * (index / 3),
      );
    });
    
    // Generate weight data for the last 7 days
    final weightData = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return FlSpot(
        index.toDouble(),
        hive.weight - hive.weightChange * (6 - index) / 6,
      );
    });
    
    // Generate humidity data for the last 7 days
    final humidityData = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return FlSpot(
        index.toDouble(),
        hive.humidity - 3 + (6 * index / 6) + (index % 2 == 0 ? -1 : 1) * (index / 3),
      );
    });

    // X-axis labels (days)
    final bottomTitles = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DateFormat('MM/dd').format(date);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChart(
            'Temperature (°C)',
            temperatureData,
            AppColors.primary,
            bottomTitles,
          ),
          const SizedBox(height: 24),
          _buildChart(
            'Weight (kg)',
            weightData,
            AppColors.secondary,
            bottomTitles,
          ),
          const SizedBox(height: 24),
          _buildChart(
            'Humidity (%)',
            humidityData,
            Colors.blue,
            bottomTitles,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(String title, List<FlSpot> data, Color color, List<String> bottomTitles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < bottomTitles.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            bottomTitles[value.toInt()],
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              minX: 0,
              maxX: data.length - 1.0,
              minY: data.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 1,
              maxY: data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 1,
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: color,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlarmsTab(List<Alarm> alarms) {
    return alarms.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.green.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No alarms for this hive',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              
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
                      const SizedBox(height: 8),
                      Text(
                        alarm.description,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Timestamp: ${DateFormat('MMM d, y H:mm').format(DateTime.parse(alarm.timestamp))}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (alarm.canDismiss)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Dismiss alarm
                            },
                            child: const Text('Dismiss'),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}