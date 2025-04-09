import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import '../widgets/bottom_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Account',
            [
              _buildSettingTile(
                'Profile',
                'Manage your account information',
                Icons.person_outline,
                () {},
              ),
              _buildSettingTile(
                'Notifications',
                'Configure alert preferences',
                Icons.notifications_none,
                () {},
              ),
              _buildSettingTile(
                'Security',
                'Password and login settings',
                Icons.security,
                () {},
              ),
            ],
          ),
          _buildSection(
            'App Settings',
            [
              _buildSettingTile(
                'Theme',
                'Light / Dark / System',
                Icons.palette_outlined,
                () {},
              ),
              _buildSettingTile(
                'Units',
                'Configure measurement units',
                Icons.straighten,
                () {},
              ),
              _buildSettingTile(
                'Language',
                'English',
                Icons.language,
                () {},
              ),
            ],
          ),
          _buildSection(
            'General',
            [
              _buildSettingTile(
                'Help & Support',
                'Contact support, FAQs',
                Icons.help_outline,
                () {},
              ),
              _buildSettingTile(
                'Privacy Policy',
                'View our privacy policy',
                Icons.privacy_tip_outlined,
                () {},
              ),
              _buildSettingTile(
                'Terms of Service',
                'View our terms of service',
                Icons.description_outlined,
                () {},
              ),
              _buildSettingTile(
                'About',
                'App version, legal information',
                Icons.info_outline,
                () {},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                authProvider.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        activeTab: 'settings',
        onTabChanged: (tab) {
          // Handle navigation
          if (tab != 'settings') {
            Navigator.of(context).pushReplacementNamed('/$tab');
          }
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}