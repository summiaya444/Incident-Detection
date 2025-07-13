import 'package:flutter/material.dart';
import 'package:incident_reporting_app/models/incident_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:lottie/lottie.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Incident> pendingIncidents = [
    Incident(
      id: 'INC001',
      imageUrl: 'assets/accident1.jpg',
      location: '24.8607° N, 67.0011° E',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      department: 'Rescue 1122',
      status: 'Pending',
      similarIncidents: 2,
    ),
    Incident(
      id: 'INC002',
      imageUrl: 'assets/fire.jpg',
      location: '24.8934° N, 67.0280° E',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      department: 'Fire Brigade',
      status: 'Pending',
      similarIncidents: 1,
    ),
  ];

  List<Incident> processedIncidents = [
    Incident(
      id: 'INC003',
      imageUrl: 'assets/medical.jpg',
      location: '24.9276° N, 67.0994° E',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      department: 'Medical Emergency',
      status: 'Approved',
      similarIncidents: 0,
    ),
  ];

  bool _isLoading = false;

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
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
            ),
            tabs: [
              Tab(
                child: badges.Badge(
                  badgeContent: Text(
                    pendingIncidents.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Text('Pending Approval'),
                ),
              ),
              const Tab(text: 'Processed'),
            ],
          ),
          actions: [
            IconButton(
              icon: badges.Badge(
                badgeContent: const Text(
                  '3',
                  style: TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.notifications),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: _isLoading
            ? _buildShimmerLoading()
            : TabBarView(
                children: [
                  _buildPendingIncidentsList(),
                  _buildProcessedIncidentsList(),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _isLoading = false;
              });
            });
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              height: 200,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingIncidentsList() {
    if (pendingIncidents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/empty.json',
              width: 200,
              height: 200,
            ),
            const Text(
              'No pending incidents',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: pendingIncidents.length,
      itemBuilder: (context, index) {
        final incident = pendingIncidents[index];
        return IncidentCard(
          incident: incident,
          isPending: true,
          onApprove: () => _approveIncident(incident),
          onReject: () => _rejectIncident(incident),
        );
      },
    );
  }

  Widget _buildProcessedIncidentsList() {
    return ListView.builder(
      itemCount: processedIncidents.length,
      itemBuilder: (context, index) {
        final incident = processedIncidents[index];
        return IncidentCard(
          incident: incident,
          isPending: false,
        );
      },
    );
  }

  void _approveIncident(Incident incident) {
    setState(() {
      pendingIncidents.remove(incident);
      processedIncidents.add(incident.copyWith(status: 'Approved'));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Incident ${incident.id} approved'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectIncident(Incident incident) {
    setState(() {
      pendingIncidents.remove(incident);
      processedIncidents.add(incident.copyWith(status: 'Rejected'));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Incident ${incident.id} rejected'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }
}

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final bool isPending;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const IncidentCard({
    super.key,
    required this.incident,
    this.isPending = false,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    incident.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      incident.id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      incident.department,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(incident.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        incident.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on, incident.location),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.access_time,
                  '${incident.time.hour}:${incident.time.minute.toString().padLeft(2, '0')} - ${incident.time.day}/${incident.time.month}/${incident.time.year}',
                ),
                if (incident.similarIncidents > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber,
                            size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '${incident.similarIncidents} similar incident(s)',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
                if (isPending) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check, size: 20),
                          label: const Text('Approve'),
                          onPressed: onApprove,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.close, size: 20),
                          label: const Text('Reject'),
                          onPressed: onReject,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
