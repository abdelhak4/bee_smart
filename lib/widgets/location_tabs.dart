import 'package:flutter/material.dart';
import '../utils/theme.dart';

class LocationTabs extends StatelessWidget {
  final List<String> locations;
  final String activeLocation;
  final Function(String) onLocationChanged;
  
  const LocationTabs({
    Key? key,
    required this.locations,
    required this.activeLocation,
    required this.onLocationChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length + 1, // +1 for the add button
        itemBuilder: (context, index) {
          if (index == locations.length) {
            // Add button
            return _buildAddButton(context);
          } else {
            final location = locations[index];
            final isActive = location == activeLocation;
            
            return _buildLocationTab(location, isActive);
          }
        },
      ),
    );
  }
  
  Widget _buildLocationTab(String location, bool isActive) {
    return InkWell(
      onTap: () => onLocationChanged(location),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          location,
          style: TextStyle(
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Show dialog to add a new location
        _showAddLocationDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Icon(
          Icons.add_circle_outline,
          color: AppColors.primary,
        ),
      ),
    );
  }
  
  void _showAddLocationDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Location'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Location Name',
              hintText: 'Enter a name for your new location',
            ),
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
                if (controller.text.isNotEmpty) {
                  // In a real app, this would call an API to create a new location
                  // For now, we'll just show a snackbar
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Location "${controller.text}" would be created here'),
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
  }
}