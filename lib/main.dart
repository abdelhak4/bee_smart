import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/apiary_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/hives_screen.dart';
import 'screens/hive_detail_screen.dart';
import 'screens/alarms_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ApiaryProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'BeeSmart',
            theme: AppTheme.lightTheme,
            home: authProvider.isAuthenticated
                ? const DashboardScreen()
                : const LoginScreen(),
            routes: {
              '/dashboard': (context) => const DashboardScreen(),
              '/hives': (context) => const HivesScreen(),
              '/alarms': (context) => const AlarmsScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/hive-detail') {
                final int hiveId = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (context) => HiveDetailScreen(hiveId: hiveId),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}