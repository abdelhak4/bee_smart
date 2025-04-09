import 'package:flutter/material.dart';
import '../utils/theme.dart';

class BottomNavigation extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChanged;
  
  const BottomNavigation({
    Key? key,
    required this.activeTab,
    required this.onTabChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                'dashboard',
                Icons.dashboard_outlined,
                Icons.dashboard,
                'Dashboard',
              ),
              _buildNavItem(
                context,
                'hives',
                Icons.hexagon_outlined,
                Icons.hexagon,
                'Hives',
              ),
              _buildNavItem(
                context,
                'alarms',
                Icons.notifications_outlined,
                Icons.notifications,
                'Alarms',
              ),
              _buildNavItem(
                context,
                'settings',
                Icons.settings_outlined,
                Icons.settings,
                'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem(
    BuildContext context,
    String tabName,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
  ) {
    final isActive = activeTab == tabName;
    
    return InkWell(
      onTap: () => onTabChanged(tabName),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? filledIcon : outlineIcon,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}