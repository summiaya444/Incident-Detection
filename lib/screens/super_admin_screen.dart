// lib/screens/super_admin_screen.dart
import 'package:flutter/material.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class SuperAdminScreen extends StatefulWidget {
  const SuperAdminScreen({super.key});

  @override
  State<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Admin Screen'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService.navigateWithReplacement(
                RouteNames.roleSelection),
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Departments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Hospitals',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildDepartmentsList();
      case 2:
        return _buildDriversList();
      case 3:
        return _buildHospitalsList();
      default:
        return Container();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'System Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Total Incidents', '247', Icons.warning),
              _buildStatCard('Today Incidents', '12', Icons.today),
              _buildStatCard('Active Departments', '5', Icons.people),
              _buildStatCard('Active Drivers', '23', Icons.directions_car),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Incidents',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.warning),
                title: Text('Incident ${index + 1}'),
                subtitle: const Text('Location: 24.8607° N, 67.0011° E'),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentsList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        final departments = [
          'Rescue 1122',
          'Traffic Police',
          'Fire Brigade',
          'Police',
          'Medical Emergency'
        ];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.people),
            title: Text(departments[index]),
            subtitle: Text('Active incidents: ${index * 2 + 1}'),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  Widget _buildDriversList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text('Driver ${index + 1}'),
            subtitle: Text(index % 3 == 0 ? 'On duty' : 'Available'),
            trailing: Chip(
              label: Text('${index + 5} cases'),
              backgroundColor: Colors.blue[100],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHospitalsList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        final hospitals = [
          'Jinnah Hospital',
          'Cardio Hospital',
          'Civil Hospital',
          'Aga Khan Hospital',
          'Liaquat National Hospital'
        ];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.local_hospital),
            title: Text(hospitals[index]),
            subtitle: Text('Today cases: ${index * 3 + 2}'),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
