import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:incident_reporting_app/screens/admin_dashboard.dart';
import 'package:incident_reporting_app/screens/department_screen.dart';
import 'package:incident_reporting_app/screens/driver_screen.dart';
import 'package:incident_reporting_app/screens/hospital_screen.dart';
import 'package:incident_reporting_app/screens/super_admin_screen.dart';
import 'package:incident_reporting_app/screens/user_report_screen.dart';
import 'package:incident_reporting_app/screens/auth/login_screen.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Role'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService.navigateWithReplacement(
                RouteNames.login),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _RoleCard(
              icon: Icons.person,
              title: 'Citizen',
              color: Colors.blue,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserReportScreen(),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(delay: 100.ms)
                .slide(begin: const Offset(-0.5, 0)),
            _RoleCard(
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              color: Colors.green,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboard(),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(delay: 200.ms)
                .slide(begin: const Offset(0.5, 0)),
            _RoleCard(
              icon: Icons.people,
              title: 'Department',
              color: Colors.orange,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DepartmentScreen(),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(delay: 300.ms)
                .slide(begin: const Offset(-0.5, 0)),
            _RoleCard(
              icon: Icons.directions_car,
              title: 'Driver',
              color: Colors.purple,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DriverScreen(),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(delay: 400.ms)
                .slide(begin: const Offset(0.5, 0)),
            _RoleCard(
              icon: Icons.local_hospital,
              title: 'Hospital',
              color: Colors.red,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HospitalScreen(),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(delay: 500.ms)
                .slide(begin: const Offset(-0.5, 0)),
            _RoleCard(
              icon: Icons.security,
              title: 'Super Admin',
              color: Colors.indigo,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuperAdminScreen(),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(delay: 600.ms)
                .slide(begin: const Offset(0.5, 0)),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
