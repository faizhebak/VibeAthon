import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/profile_screen.dart';
import '../screens/auth/profile_setup_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/dashboard/reports_screen.dart';
import '../screens/fuel/add_fuel_entry_screen.dart';
import '../screens/fuel/fuel_entry_detail_screen.dart';
import '../screens/fuel/fuel_log_screen.dart';
import '../screens/garage/add_vehicle_screen.dart';
import '../screens/garage/garage_screen.dart';
import '../screens/garage/vehicle_detail_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/placeholder_screen.dart';
import '../screens/price/price_screen.dart';
import '../screens/price/refuel_advisor_screen.dart';
import '../screens/splash_screen.dart';
import '../widgets/shell/app_shell.dart';

class RoutePaths {
  RoutePaths._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String profileSetup = '/profile-setup';
  static const String home = '/home';
  static const String fuel = '/fuel';
  static const String addFuel = '/fuel/add';
  static const String fuelDetail = '/fuel/:id';
  static const String reports = '/reports';
  static const String reportsDetail = '/reports/detail';
  static const String price = '/price';
  static const String refuelAdvisor = '/price/advisor';
  static const String garage = '/garage';
  static const String addVehicle = '/garage/add';
  static const String vehicleDetail = '/garage/:id';
  static const String ai = '/ai';
  static const String driving = '/driving';
  static const String tripDetail = '/driving/:id';
  static const String carbon = '/carbon';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
}

abstract class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isAuthRoute =
            state.matchedLocation == RoutePaths.login ||
            state.matchedLocation == RoutePaths.register ||
            state.matchedLocation == RoutePaths.profileSetup ||
            state.matchedLocation == RoutePaths.splash;

        if (!isLoggedIn && !isAuthRoute) return RoutePaths.login;
        if (isLoggedIn &&
            (state.matchedLocation == RoutePaths.login ||
                state.matchedLocation == RoutePaths.register)) {
          return RoutePaths.home;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: RoutePaths.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RoutePaths.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: RoutePaths.profileSetup,
          builder: (context, state) => const ProfileSetupScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return AppShell(
              currentIndex: _indexForLocation(state.matchedLocation),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: RoutePaths.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: RoutePaths.fuel,
              builder: (context, state) => const FuelLogScreen(),
            ),
            GoRoute(
              path: RoutePaths.addFuel,
              builder: (context, state) => const AddFuelEntryScreen(),
            ),
            GoRoute(
              path: RoutePaths.fuelDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return FuelEntryDetailScreen(entryId: id);
              },
            ),
            GoRoute(
              path: RoutePaths.reports,
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: RoutePaths.garage,
              builder: (context, state) => const GarageScreen(),
            ),
            GoRoute(
              path: RoutePaths.addVehicle,
              builder: (context, state) => const AddVehicleScreen(),
            ),
            GoRoute(
              path: RoutePaths.vehicleDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return VehicleDetailScreen(vehicleId: id);
              },
            ),
            GoRoute(
              path: RoutePaths.ai,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'AI BudiBuddy'),
            ),
            GoRoute(
              path: RoutePaths.driving,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Driving'),
            ),
            GoRoute(
              path: RoutePaths.tripDetail,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Trip Detail'),
            ),
            GoRoute(
              path: RoutePaths.carbon,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Carbon'),
            ),
            GoRoute(
              path: RoutePaths.notifications,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Notifications'),
            ),
            GoRoute(
              path: RoutePaths.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.reportsDetail,
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: RoutePaths.price,
          builder: (context, state) => const PriceScreen(),
        ),
        GoRoute(
          path: RoutePaths.refuelAdvisor,
          builder: (context, state) => const RefuelAdvisorScreen(),
        ),
      ],
    );
  }

  static int _indexForLocation(String location) {
    if (location.startsWith(RoutePaths.fuel)) return 1;
    if (location.startsWith(RoutePaths.reports)) return 2;
    if (location.startsWith(RoutePaths.garage)) return 3;
    if (location.startsWith(RoutePaths.ai)) return 4;
    return 0;
  }
}
