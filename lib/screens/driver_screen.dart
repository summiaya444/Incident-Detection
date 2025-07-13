// lib/screens/driver_screen.dart
import 'package:flutter/material.dart';
import 'package:incident_reporting_app/models/incident_model.dart';
import 'package:incident_reporting_app/widgets/incident_card.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  List<Incident> assignedIncidents = [
    Incident(
      id: 'INC001',
      imageUrl: 'assets/accident1.jpg',
      location: '24.8607° N, 67.0011° E',
      time: DateTime.now().subtract(const Duration(minutes: 45)),
      department: 'Rescue 1122',
      status: 'On the way',
      assignedTo: 'Driver 1',
    ),
  ];

  List<Incident> completedIncidents = [
    Incident(
      id: 'INC003',
      imageUrl: 'assets/medical.jpg',
      location: '24.9276° N, 67.0994° E',
      time: DateTime.now().subtract(const Duration(days: 1)),
      department: 'Medical Emergency',
      status: 'Completed - Patient taken to Jinnah Hospital',
      assignedTo: 'Driver 1',
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
              Tab(text: 'Assigned Incidents'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAssignedIncidentsList(),
            _buildCompletedIncidentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedIncidentsList() {
    return ListView.builder(
      itemCount: assignedIncidents.length,
      itemBuilder: (context, index) {
        final incident = assignedIncidents[index];
        return IncidentActionCard(
          incident: incident,
          onStatusUpdate: (status) => _updateIncidentStatus(incident, status),
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

  void _updateIncidentStatus(Incident incident, String status) {
    setState(() {
      assignedIncidents.remove(incident);
      completedIncidents.add(incident.copyWith(status: status));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Incident ${incident.id} status updated')),
    );
  }
}

class IncidentActionCard extends StatelessWidget {
  final Incident incident;
  final Function(String) onStatusUpdate;

  const IncidentActionCard({
    super.key,
    required this.incident,
    required this.onStatusUpdate,
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
                const Text(
                  'Update Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Arrived'),
                      onPressed: () => _showPatientStatusDialog(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPatientStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Patient Status'),
        content: const Text('Please select the current status of the patient:'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              onStatusUpdate('Patient expired - Body taken to Jinnah Hospital');
            },
            child: const Text('Expired (Red)'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              onStatusUpdate('Patient taken by someone else');
            },
            child: const Text('Taken by Others (Blue)'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showHospitalSelectionDialog(context);
            },
            child: const Text('Transporting (Green)'),
          ),
        ],
      ),
    );
  }

  void _showHospitalSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Hospital'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Jinnah Hospital'),
              onTap: () {
                Navigator.pop(context);
                onStatusUpdate('Patient taken to Jinnah Hospital');
                _showFeedbackForm(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Cardio Hospital'),
              onTap: () {
                Navigator.pop(context);
                onStatusUpdate('Patient taken to Cardio Hospital');
                _showFeedbackForm(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Incident Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Patient Hospital ID (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.mic),
              label: const Text('Record Voice Feedback'),
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback submitted')),
                );
              },
              child: const Text('SUBMIT FEEDBACK'),
            ),
          ],
        ),
      ),
    );
  }
}
