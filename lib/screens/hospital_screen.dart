// lib/screens/hospital_screen.dart
import 'package:flutter/material.dart';
import 'package:incident_reporting_app/models/incident_model.dart';
import 'package:incident_reporting_app/widgets/incident_card.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  List<Incident> incomingCases = [
    Incident(
      id: 'INC001',
      imageUrl: 'assets/accident1.jpg',
      location: '24.8607° N, 67.0011° E',
      time: DateTime.now().subtract(const Duration(minutes: 55)),
      department: 'Rescue 1122',
      status: 'Ambulance on the way - ETA: 15 min',
      assignedTo: 'Driver 1',
    ),
  ];

  List<Incident> receivedCases = [
    Incident(
      id: 'INC003',
      imageUrl: 'assets/medical.jpg',
      location: '24.9276° N, 67.0994° E',
      time: DateTime.now().subtract(const Duration(days: 1)),
      department: 'Medical Emergency',
      status: 'Patient received - Ward 5',
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
              Tab(text: 'Incoming Cases'),
              Tab(text: 'Received Cases'),
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
            _buildIncomingCasesList(),
            _buildReceivedCasesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingCasesList() {
    return ListView.builder(
      itemCount: incomingCases.length,
      itemBuilder: (context, index) {
        final incident = incomingCases[index];
        return IncomingCaseCard(incident: incident);
      },
    );
  }

  Widget _buildReceivedCasesList() {
    return ListView.builder(
      itemCount: receivedCases.length,
      itemBuilder: (context, index) {
        final incident = receivedCases[index];
        return IncidentCard(incident: incident);
      },
    );
  }
}

class IncomingCaseCard extends StatelessWidget {
  final Incident incident;

  const IncomingCaseCard({super.key, required this.incident});

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
                      label: const Text('Incoming'),
                      backgroundColor: Colors.orange[100],
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
                const SizedBox(height: 8),
                const Text(
                  'Ambulance Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 8),
                Text(incident.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
