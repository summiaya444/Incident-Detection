import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as badges;
import 'package:incident_reporting_app/models/incident_model.dart';
import 'package:incident_reporting_app/widgets/incident_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late AnimationController _pulseController;

  final Map<String, String> incidentPriorities = {
    'INC001': 'High',
    'INC002': 'Critical',
    'INC003': 'Medium',
    'INC004': 'Low',
    'INC005': 'Medium',
  };

  final Map<String, String> incidentReporters = {
    'INC001': 'Ahmed Khan',
    'INC002': 'Sara Ali',
    'INC003': 'Hassan Ahmed',
    'INC004': 'Fatima Sheikh',
    'INC005': 'Ali Raza',
  };

  List<Incident> pendingIncidents = [
    Incident(
      id: 'INC001',
      imageUrl: 'assets/images/bg_pattern.jpg',
      location: 'Clifton Bridge, Karachi',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      department: 'Rescue 1122',
      status: 'Pending',
      similarIncidents: 2,
    ),
    Incident(
      id: 'INC002',
      imageUrl: 'assets/images/bg_pattern.jpg',
      location: 'DHA Phase 5, Karachi',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      department: 'Fire Brigade',
      status: 'Pending',
      similarIncidents: 1,
    ),
    Incident(
      id: 'INC003',
      imageUrl: 'assets/medical.jpg',
      location: 'Gulshan-e-Iqbal, Karachi',
      time: DateTime.now().subtract(const Duration(minutes: 45)),
      department: 'Medical Emergency',
      status: 'Pending',
      similarIncidents: 0,
    ),
  ];

  List<Incident> processedIncidents = [
    Incident(
      id: 'INC004',
      imageUrl: 'assets/medical.jpg',
      location: 'Saddar, Karachi',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      department: 'Medical Emergency',
      status: 'Approved',
      similarIncidents: 0,
    ),
    Incident(
      id: 'INC005',
      imageUrl: 'assets/accident1.jpg',
      location: 'II Chundrigar Road, Karachi',
      time: DateTime.now().subtract(const Duration(hours: 4)),
      department: 'Traffic Police',
      status: 'Rejected',
      similarIncidents: 1,
    ),
  ];

  bool _isLoading = false;
  int _selectedTabIndex = 0;

  int get totalReports => pendingIncidents.length + processedIncidents.length;
  int get pendingReview => pendingIncidents.length;
  int get approvedReports =>
      processedIncidents.where((i) => i.status == 'Approved').length;
  int get rejectedReports =>
      processedIncidents.where((i) => i.status == 'Rejected').length;
  int get duplicates =>
      pendingIncidents.where((i) => i.similarIncidents > 0).length +
      processedIncidents.where((i) => i.similarIncidents > 0).length;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(context),
        body: _isLoading
            ? _buildShimmerLoading()
            : TabBarView(
                children: [
                  _buildPendingTab(),
                  _buildProcessedTab(),
                ],
              ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () =>
            NavigationService.navigateWithReplacement(RouteNames.roleSelection),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admin Control Center',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Incident Management System',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black87),
              onPressed: () => _showNotificationsDialog(context),
            ),
            if (pendingReview > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$pendingReview',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black87),
          onPressed: () {},
        ),
      ],
      bottom: TabBar(
        onTap: (index) => setState(() => _selectedTabIndex = index),
        labelColor: Colors.red[600],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.red[600],
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Pending'),
                if (pendingIncidents.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${pendingIncidents.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Processed'),
                if (processedIncidents.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${processedIncidents.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildPendingTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Alert Section for pending incidents
          if (pendingIncidents.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[100]!, Colors.red[50]!],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + 0.1 * _pulseController.value,
                        child: Icon(
                          Icons.warning,
                          color: Colors.red[600],
                          size: 28,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Action Required',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${pendingIncidents.length} incident(s) awaiting review',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.red[600], size: 20),
                ],
              ),
            ).animate().fadeIn().slide(),

          // Statistics Cards
          _buildStatisticsSection(),

          const SizedBox(height: 16),

          // Pending Incidents List
          _buildPendingIncidentsList(),
        ],
      ),
    );
  }

  Widget _buildProcessedTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildProcessedStatistics(),
          const SizedBox(height: 16),
          _buildProcessedIncidentsList(),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildStatCard(
                'Total Reports',
                totalReports.toString(),
                Icons.description,
                Colors.blue,
              ),
              _buildStatCard(
                'Pending Review',
                pendingReview.toString(),
                Icons.pending_actions,
                Colors.orange,
              ),
              _buildStatCard(
                'Approved',
                approvedReports.toString(),
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatCard(
                'Duplicates',
                duplicates.toString(),
                Icons.warning,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessedStatistics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Processing Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Approved',
                  approvedReports.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Rejected',
                  rejectedReports.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100));
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            height: 200,
          ),
        );
      },
    );
  }

  Widget _buildPendingIncidentsList() {
    if (pendingIncidents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/empty.json',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 16),
              const Text(
                'No pending incidents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All incidents have been reviewed',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: pendingIncidents.length,
      itemBuilder: (context, index) {
        final incident = pendingIncidents[index];
        return IncidentCard(
          incident: incident,
          isPending: true,
          isAdminView: true,
          onApprove: () => _approveIncident(incident),
          onReject: () => _rejectIncident(incident),
          onAssignDepartment: () => _showDepartmentDialog(incident),
          incidentPriorities: incidentPriorities,
          incidentReporters: incidentReporters,
        );
      },
    );
  }

  Widget _buildProcessedIncidentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: processedIncidents.length,
      itemBuilder: (context, index) {
        final incident = processedIncidents[index];
        return IncidentCard(
          incident: incident,
          isPending: false,
          isAdminView: true,
          incidentPriorities: incidentPriorities,
          incidentReporters: incidentReporters,
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _refreshData(),
      backgroundColor: Colors.red[600],
      elevation: 4,
      icon: RotationTransition(
        turns: _refreshController,
        child: const Icon(Icons.refresh, color: Colors.white, size: 20),
      ),
      label: const Text(
        'Refresh',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  void _refreshData() {
    setState(() => _isLoading = true);
    _refreshController.repeat();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      _refreshController.stop();
      _refreshController.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Dashboard refreshed successfully',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }

  void _approveIncident(Incident incident) {
    setState(() {
      pendingIncidents.remove(incident);
      processedIncidents.insert(0, incident.copyWith(status: 'Approved'));
    });

    _showSuccessDialog(
      'Incident Approved',
      'Incident ${incident.id} has been approved and forwarded to ${incident.department}.',
      Icons.check_circle,
      Colors.green,
    );
  }

  void _rejectIncident(Incident incident) {
    setState(() {
      pendingIncidents.remove(incident);
      processedIncidents.insert(0, incident.copyWith(status: 'Rejected'));
    });

    _showSuccessDialog(
      'Incident Rejected',
      'Incident ${incident.id} has been rejected. Reporter has been notified.',
      Icons.cancel,
      Colors.red,
    );
  }

  void _showDepartmentDialog(Incident incident) {
    final departments = [
      'Rescue 1122',
      'Fire Brigade',
      'Medical Emergency',
      'Traffic Police',
      'Bomb Disposal',
      'K-Electric',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Assign Department',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select department for incident ${incident.id}:',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ...departments.map((dept) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                      ),
                      title: Text(
                        dept,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        Navigator.pop(context);
                        _assignToDepartment(incident, dept);
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _assignToDepartment(Incident incident, String department) {
    setState(() {
      final index = pendingIncidents.indexOf(incident);
      if (index != -1) {
        pendingIncidents[index] = incident.copyWith(department: department);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Incident ${incident.id} assigned to $department',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog(
      String title, String message, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.notifications, color: Colors.red[600], size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNotificationItem(
                'High Priority Incident',
                'New accident reported at Clifton Bridge',
                Icons.warning,
                Colors.red,
                '2 min ago',
              ),
              _buildNotificationItem(
                'Department Alert',
                'Fire Brigade has accepted INC002',
                Icons.local_fire_department,
                Colors.orange,
                '15 min ago',
              ),
              _buildNotificationItem(
                'System Update',
                'Dashboard refreshed successfully',
                Icons.update,
                Colors.blue,
                '1 hour ago',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      String title, String subtitle, IconData icon, Color color, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
