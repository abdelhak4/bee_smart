import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/apiary_provider.dart';
import '../utils/mock_data.dart';
import '../utils/theme.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/location_tabs.dart';
import '../widgets/status_indicator.dart';

class HivesScreen extends StatefulWidget {
  const HivesScreen({Key? key}) : super(key: key);

  @override
  _HivesScreenState createState() => _HivesScreenState();
}

class _HivesScreenState extends State<HivesScreen> {
  String _selectedStatusFilter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiaryProvider = Provider.of<ApiaryProvider>(context);
    final activeLocation = apiaryProvider.activeLocation;
    
    // Get hives for this location
    final allHives = MockData.getHivesByLocation(activeLocation);
    
    // Apply status filter
    List<Hive> filteredHives = allHives;
    if (_selectedStatusFilter != 'all') {
      filteredHives = allHives.where((hive) => hive.status == _selectedStatusFilter).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredHives = filteredHives
          .where((hive) => hive.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hives'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
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
                _buildFilterChip('strong', 'Strong'),
                _buildFilterChip('improving', 'Improving'),
                _buildFilterChip('declining', 'Declining'),
                _buildFilterChip('wintering', 'Wintering'),
                _buildFilterChip('danger', 'Danger'),
              ],
            ),
          ),
          
          // Search bar (if query exists)
          if (_searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search: "$_searchQuery"',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          
          // Hives count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${filteredHives.length} ${_selectedStatusFilter != 'all' ? _selectedStatusFilter : ''} hive${filteredHives.length != 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          
          // Hives list
          Expanded(
            child: filteredHives.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredHives.length,
                    itemBuilder: (context, index) {
                      return _buildHiveCard(context, filteredHives[index]);
                    },
                  ),
          ),
        ],
      ),
      // FAB to add a new hive
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          // Show dialog to add a new hive
          _showAddHiveDialog(context);
        },
      ),
      bottomNavigationBar: BottomNavigation(
        activeTab: 'hives',
        onTabChanged: (tab) {
          // Handle navigation
          if (tab != 'hives') {
            Navigator.of(context).pushReplacementNamed('/$tab');
          }
        },
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedStatusFilter == value;
    
    Color chipColor;
    if (value == 'all') {
      chipColor = AppColors.textSecondary;
    } else {
      switch (value) {
        case 'strong':
          chipColor = Colors.green;
          break;
        case 'improving':
          chipColor = Colors.lightGreen;
          break;
        case 'declining':
          chipColor = Colors.orange;
          break;
        case 'wintering':
          chipColor = Colors.blue;
          break;
        case 'danger':
          chipColor = Colors.red;
          break;
        default:
          chipColor = AppColors.textSecondary;
      }
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
            _selectedStatusFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildHiveCard(BuildContext context, Hive hive) {
    // Get gateway for this hive
    final gateway = MockData.gateways.firstWhere(
      (g) => g.id == hive.gatewayId,
      orElse: () => MockData.gateways.first,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/hive-detail',
            arguments: hive.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.hexagon,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hive.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Gateway: ${gateway.name}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusIndicator(status: hive.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildHiveMetric(
                    'Temperature',
                    '${hive.temperature.toStringAsFixed(1)}°C',
                    Icons.thermostat_outlined,
                  ),
                  _buildHiveMetric(
                    'Humidity',
                    '${hive.humidity.toStringAsFixed(1)}%',
                    Icons.opacity_outlined,
                  ),
                  _buildHiveMetric(
                    'Weight',
                    '${hive.weight.toStringAsFixed(1)}kg',
                    Icons.monitor_weight_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        hive.weightChange >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: 16,
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
                  Text(
                    'Last update: ${_getFormattedTime(hive.lastUpdate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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

  Widget _buildHiveMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hexagon_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No hives found matching "$_searchQuery"'
                : _selectedStatusFilter != 'all'
                    ? 'No ${_selectedStatusFilter} hives'
                    : 'No hives in this location',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          if (_searchQuery.isNotEmpty || _selectedStatusFilter != 'all')
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                    _selectedStatusFilter = 'all';
                  });
                },
                child: const Text('Clear Filters'),
              ),
            ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Hives'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Enter hive name',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              setState(() {
                _searchQuery = value.trim();
              });
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = _searchController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Hives'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Hives'),
                leading: Radio<String>(
                  value: 'all',
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Strong'),
                  ],
                ),
                leading: Radio<String>(
                  value: 'strong',
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Improving'),
                  ],
                ),
                leading: Radio<String>(
                  value: 'improving',
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Declining'),
                  ],
                ),
                leading: Radio<String>(
                  value: 'declining',
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Wintering'),
                  ],
                ),
                leading: Radio<String>(
                  value: 'wintering',
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Danger'),
                  ],
                ),
                leading: Radio<String>(
                  value: 'danger',
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
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

  void _showAddHiveDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    String selectedGateway = '';
    
    final apiaryProvider = Provider.of<ApiaryProvider>(context, listen: false);
    final gateways = MockData.getGatewaysByLocation(apiaryProvider.activeLocation);
    
    if (gateways.isNotEmpty) {
      selectedGateway = gateways[0].name;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Hive'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Hive Name',
                      hintText: 'Enter a name for the hive',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gateway',
                      hintText: 'Select a gateway',
                    ),
                    value: selectedGateway.isNotEmpty ? selectedGateway : null,
                    items: gateways
                        .map((gateway) => DropdownMenuItem(
                              value: gateway.name,
                              child: Text(gateway.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedGateway = value;
                        });
                      }
                    },
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
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && selectedGateway.isNotEmpty) {
                      // In a real app, this would call an API to create a new hive
                      // For now, we'll just show a snackbar
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Hive "${nameController.text}" would be created here'),
                        ),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
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