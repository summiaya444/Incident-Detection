import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';
import 'package:incident_reporting_app/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:incident_reporting_app/screens/onboarding_screen.dart';
import 'package:incident_reporting_app/screens/auth/login_screen.dart';
import 'package:incident_reporting_app/screens/auth/register_screen.dart';
import 'package:incident_reporting_app/screens/role_selection_screen.dart';
import 'package:incident_reporting_app/screens/admin_dashboard.dart';
import 'package:incident_reporting_app/screens/department_screen.dart';
import 'package:incident_reporting_app/screens/driver_screen.dart';
import 'package:incident_reporting_app/screens/hospital_screen.dart';
import 'package:incident_reporting_app/screens/super_admin_screen.dart';
import 'package:incident_reporting_app/screens/user_report_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Emergency Response',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      initialRoute: RouteNames.onboarding,
      routes: {
        RouteNames.onboarding: (context) => OnboardingScreen(toggleTheme: toggleTheme),
        RouteNames.login: (context) => const LoginScreen(),
        RouteNames.register: (context) => const RegisterScreen(),
        RouteNames.roleSelection: (context) => const RoleSelectionScreen(),
        RouteNames.adminDashboard: (context) => const AdminDashboard(),
        RouteNames.departmentScreen: (context) => const DepartmentScreen(),
        RouteNames.driverScreen: (context) => const DriverScreen(),
        RouteNames.hospitalScreen: (context) => const HospitalScreen(),
        RouteNames.superAdminScreen: (context) => const SuperAdminScreen(),
        RouteNames.userReportScreen: (context) => const UserReportScreen(),
      },
    );
  }
}