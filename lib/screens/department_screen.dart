// lib/screens/department_screen.dart
import 'package:flutter/material.dart';
import 'package:incident_reporting_app/models/incident_model.dart';
import 'package:incident_reporting_app/widgets/incident_card.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  List<Incident> activeIncidents = [
    Incident(
      id: 'INC001',
      imageUrl: 'assets/accident1.jpg',
      location: '24.8607° N, 67.0011° E',
      time: DateTime.now().subtract(const Duration(minutes: 25)),
      department: 'Rescue 1122',
      status: 'Assigned',
      accepted: false,
    ),
  ];

  List<Incident> completedIncidents = [
    Incident(
      id: 'INC003',
      imageUrl: 'assets/medical.jpg',
      location: '24.9276° N, 67.0994° E',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      department: 'Medical Emergency',
      status: 'Completed',
      accepted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService.navigateWithReplacement(
                RouteNames.roleSelection),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Incidents'),
              Tab(text: 'Completed'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildActiveIncidentsList(),
            _buildCompletedIncidentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveIncidentsList() {
    return ListView.builder(
      itemCount: activeIncidents.length,
      itemBuilder: (context, index) {
        final incident = activeIncidents[index];
        return IncidentAssignmentCard(
          incident: incident,
          onAccept: () => _acceptIncident(incident),
          onAssign: (driver) => _assignToDriver(incident, driver),
        );
      },
    );
  }

  Widget _buildCompletedIncidentsList() {
    return ListView.builder(
      itemCount: completedIncidents.length,
      itemBuilder: (context, index) {
        final incident = completedIncidents[index];
        return IncidentCard(incident: incident);
      },
    );
  }

  void _acceptIncident(Incident incident) {
    setState(() {
      activeIncidents = activeIncidents.map((i) {
        if (i.id == incident.id) {
          return i.copyWith(accepted: true);
        }
        return i;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Incident ${incident.id} accepted')),
    );
  }

  void _assignToDriver(Incident incident, String driver) {
    setState(() {
      activeIncidents = activeIncidents.map((i) {
        if (i.id == incident.id) {
          return i.copyWith(assignedTo: driver, status: 'Assigned to Driver');
        }
        return i;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Incident ${incident.id} assigned to $driver')),
    );
  }
}

class IncidentAssignmentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback onAccept;
  final Function(String) onAssign;

  const IncidentAssignmentCard({
    super.key,
    required this.incident,
    required this.onAccept,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              incident.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${incident.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(incident.status),
                      backgroundColor: Colors.blue[100],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Department: ${incident.department}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(incident.location),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(
                        '${incident.time.hour}:${incident.time.minute} - ${incident.time.day}/${incident.time.month}/${incident.time.year}'),
                  ],
                ),
                const SizedBox(height: 16),
                if (incident.accepted != true)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: onAccept,
                    child: const Text('ACCEPT INCIDENT'),
                  ),
                if (incident.accepted == true) ...[
                  const Text(
                    'Assign to Driver:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    items: ['Driver 1', 'Driver 2', 'Driver 3']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onAssign(value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select Driver',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
