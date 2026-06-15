import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/local_storage.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'providers/ai_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/carbon_provider.dart';
import 'providers/driving_provider.dart';
import 'providers/fuel_provider.dart';
import 'providers/vehicle_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => FuelProvider()),
        ChangeNotifierProvider(create: (_) => DrivingProvider()),
        ChangeNotifierProvider(create: (_) => CarbonProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
      ],
      child: const BudiBuddyApp(),
    ),
  );
}

class BudiBuddyApp extends StatelessWidget {
  const BudiBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return MaterialApp.router(
      title: 'BudiBuddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.createRouter(authProvider),
    );
  }
}
