import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/apiary_provider.dart';
import '../utils/mock_data.dart';
import '../utils/theme.dart';
import '../widgets/alarm_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/location_tabs.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  String _selectedSeverityFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final apiaryProvider = Provider.of<ApiaryProvider>(context);
    final activeLocation = apiaryProvider.activeLocation;
    final allAlarms = MockData.alarms;
    
    // Filter alarms by location
    List<Alarm> locationAlarms = [];
    for (var alarm in allAlarms) {
      if (alarm.hiveId != null) {
        final hive = MockData.getHiveById(alarm.hiveId!);
        if (hive != null && hive.location == activeLocation) {
          locationAlarms.add(alarm);
          continue;
        }
      }
      
      if (alarm.gatewayId != null) {
        final gateway = MockData.gateways.firstWhere(
          (g) => g.id == alarm.gatewayId,
          orElse: () => MockData.gateways.first,
        );
        if (gateway.location == activeLocation) {
          locationAlarms.add(alarm);
        }
      }
    }
    
    // Apply severity filter
    List<Alarm> filteredAlarms = locationAlarms;
    if (_selectedSeverityFilter != 'all') {
      filteredAlarms = locationAlarms.where((a) => a.severity == _selectedSeverityFilter).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
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

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('all', 'All'),
                _buildFilterChip('high', 'High'),
                _buildFilterChip('medium', 'Medium'),
                _buildFilterChip('low', 'Low'),
                _buildFilterChip('info', 'Info'),
              ],
            ),
          ),

          // Alarms count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${filteredAlarms.length} ${_selectedSeverityFilter != 'all' ? _selectedSeverityFilter : ''} alarm${filteredAlarms.length != 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Alarms list
          Expanded(
            child: filteredAlarms.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAlarms.length,
                    itemBuilder: (context, index) {
                      return AlarmCard(
                        alarm: filteredAlarms[index],
                        onDismiss: filteredAlarms[index].canDismiss
                            ? () {
                                _dismissAlarm(filteredAlarms[index]);
                              }
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        activeTab: 'alarms',
        onTabChanged: (tab) {
          // Handle navigation
          if (tab != 'alarms') {
            Navigator.of(context).pushReplacementNamed('/$tab');
          }
        },
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedSeverityFilter == value;
    
    Color chipColor = AppColors.textSecondary;
    if (value != 'all') {
      chipColor = AppTheme.getSeverityColor(value);
    }
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : chipColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
        selectedColor: chipColor,
        side: BorderSide(color: chipColor),
        onSelected: (selected) {
          setState(() {
            _selectedSeverityFilter = value;
          });
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Alarms'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Alarms'),
                leading: Radio<String>(
                  value: 'all',
                  groupValue: _selectedSeverityFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverityFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('High Severity'),
                leading: Radio<String>(
                  value: 'high',
                  groupValue: _selectedSeverityFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverityFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Medium Severity'),
                leading: Radio<String>(
                  value: 'medium',
                  groupValue: _selectedSeverityFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverityFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Low Severity'),
                leading: Radio<String>(
                  value: 'low',
                  groupValue: _selectedSeverityFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverityFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Informational'),
                leading: Radio<String>(
                  value: 'info',
                  groupValue: _selectedSeverityFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverityFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _dismissAlarm(Alarm alarm) {
    // In a real app, this would make an API call to dismiss the alarm
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm "${alarm.title}" dismissed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo logic would go here
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedSeverityFilter != 'all'
                ? 'No ${_selectedSeverityFilter} alarms'
                : 'No alarms for this location',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          if (_selectedSeverityFilter != 'all')
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedSeverityFilter = 'all';
                  });
                },
                child: const Text('Show All Alarms'),
              ),
            ),
        ],
      ),
    );
  }
}