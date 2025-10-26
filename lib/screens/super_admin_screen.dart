import 'package:flutter/material.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class SuperAdminScreen extends StatefulWidget {
  const SuperAdminScreen({super.key});

  @override
  State<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late AnimationController _pulseController;

  int _currentIndex = 0;
  bool _isLoading = false;
  String _selectedTimeFrame = 'Today';
  String _searchQuery = '';

  // System-wide statistics
  final Map<String, dynamic> systemStats = {
    'totalIncidents': 247,
    'todayIncidents': 12,
    'activeIncidents': 8,
    'resolvedToday': 10,
    'pendingApproval': 3,
    'totalUsers': 156,
    'activeDrivers': 23,
    'totalDepartments': 5,
    'totalHospitals': 5,
    'totalAdmins': 3,
    'avgResponseTime': '14 min',
    'systemUptime': '99.8%',
    'totalReports': 247,
    'criticalIncidents': 2,
  };

  // Users/Reporters data
  final List<Map<String, dynamic>> users = [
    {
      'name': 'Ahmed Khan',
      'email': 'ahmed@test.com',
      'status': 'Active',
      'reports': 15,
      'lastActive': '5 min ago',
      'joinedDate': 'Jan 15, 2024',
      'phone': '+92 300 1234567',
      'verificationStatus': 'Verified',
      'rating': 4.5,
    },
    {
      'name': 'Sara Ali',
      'email': 'sara@test.com',
      'status': 'Active',
      'reports': 8,
      'lastActive': '12 min ago',
      'joinedDate': 'Feb 20, 2024',
      'phone': '+92 301 2345678',
      'verificationStatus': 'Verified',
      'rating': 4.7,
    },
    {
      'name': 'Hassan Ahmed',
      'email': 'hassan@test.com',
      'status': 'Inactive',
      'reports': 23,
      'lastActive': '2 hours ago',
      'joinedDate': 'Dec 10, 2023',
      'phone': '+92 302 3456789',
      'verificationStatus': 'Pending',
      'rating': 4.2,
    },
  ];

  // Drivers data
  final List<Map<String, dynamic>> drivers = [
    {
      'name': 'Ali Raza',
      'email': 'ali.driver@test.com',
      'status': 'BUSY',
      'location': 'En route to incident',
      'completedToday': 5,
      'totalCompleted': 234,
      'department': 'Rescue 1122',
      'rating': 4.8,
      'vehicle': 'AMB-123',
      'license': 'DL-456789',
      'currentIncident': 'INC247',
      'joinedDate': 'Jan 2023',
    },
    {
      'name': 'Fatima Sheikh',
      'email': 'fatima.driver@test.com',
      'status': 'AVAILABLE',
      'location': 'Station',
      'completedToday': 3,
      'totalCompleted': 189,
      'department': 'Medical Emergency',
      'rating': 4.9,
      'vehicle': 'AMB-456',
      'license': 'DL-123456',
      'currentIncident': null,
      'joinedDate': 'Mar 2023',
    },
    {
      'name': 'John Smith',
      'email': 'john.driver@test.com',
      'status': 'OFFLINE',
      'location': 'N/A',
      'completedToday': 0,
      'totalCompleted': 156,
      'department': 'Fire Brigade',
      'rating': 4.7,
      'vehicle': 'AMB-789',
      'license': 'DL-789012',
      'currentIncident': null,
      'joinedDate': 'Jun 2022',
    },
  ];

  // Departments data
  final List<Map<String, dynamic>> departments = [
    {
      'name': 'Rescue 1122',
      'email': 'rescue@dept.com',
      'activeIncidents': 3,
      'todayIncidents': 8,
      'totalIncidents': 89,
      'drivers': 6,
      'availableDrivers': 4,
      'avgResponse': '12 min',
      'status': 'Active',
      'manager': 'Muhammad Akram',
      'managerPhone': '+92 300 1111111',
      'location': 'Main Station, Karachi',
      'establishedDate': '2004',
    },
    {
      'name': 'Traffic Police',
      'email': 'traffic@dept.com',
      'activeIncidents': 2,
      'todayIncidents': 5,
      'totalIncidents': 67,
      'drivers': 5,
      'availableDrivers': 3,
      'avgResponse': '15 min',
      'status': 'Active',
      'manager': 'Imran Khan',
      'managerPhone': '+92 300 2222222',
      'location': 'Traffic HQ, Karachi',
      'establishedDate': '1960',
    },
    {
      'name': 'Fire Brigade',
      'email': 'fire@dept.com',
      'activeIncidents': 1,
      'todayIncidents': 3,
      'totalIncidents': 45,
      'drivers': 4,
      'availableDrivers': 3,
      'avgResponse': '10 min',
      'status': 'Active',
      'manager': 'Asif Ali',
      'managerPhone': '+92 300 3333333',
      'location': 'Fire Station, Saddar',
      'establishedDate': '1947',
    },
    {
      'name': 'Medical Emergency',
      'email': 'medical@dept.com',
      'activeIncidents': 2,
      'todayIncidents': 6,
      'totalIncidents': 78,
      'drivers': 5,
      'availableDrivers': 2,
      'avgResponse': '13 min',
      'status': 'Active',
      'manager': 'Dr. Sarah Khan',
      'managerPhone': '+92 300 4444444',
      'location': 'Emergency Center, Clifton',
      'establishedDate': '2010',
    },
    {
      'name': 'Police',
      'email': 'police@dept.com',
      'activeIncidents': 0,
      'todayIncidents': 4,
      'totalIncidents': 56,
      'drivers': 3,
      'availableDrivers': 3,
      'avgResponse': '18 min',
      'status': 'Active',
      'manager': 'Inspector Raza',
      'managerPhone': '+92 300 5555555',
      'location': 'Police Station, Defence',
      'establishedDate': '1947',
    },
  ];

  // Hospitals data
  final List<Map<String, dynamic>> hospitals = [
    {
      'name': 'Jinnah Hospital',
      'email': 'jinnah@hospital.com',
      'todayCases': 8,
      'totalCases': 156,
      'availableBeds': 12,
      'totalBeds': 50,
      'occupancyRate': '76%',
      'status': 'Active',
      'avgWaitTime': '25 min',
      'activeStaff': 45,
      'totalStaff': 52,
      'location': 'Main City',
      'contact': '+92 300 6666666',
      'emergencyServices': ['ICU', 'Emergency', 'Trauma'],
      'rating': 4.3,
    },
    {
      'name': 'Aga Khan Hospital',
      'email': 'agakhan@hospital.com',
      'todayCases': 6,
      'totalCases': 134,
      'availableBeds': 8,
      'totalBeds': 45,
      'occupancyRate': '82%',
      'status': 'Active',
      'avgWaitTime': '20 min',
      'activeStaff': 38,
      'totalStaff': 45,
      'location': 'Stadium Road',
      'contact': '+92 300 7777777',
      'emergencyServices': ['ICU', 'Emergency', 'Cardiac'],
      'rating': 4.8,
    },
    {
      'name': 'Civil Hospital',
      'email': 'civil@hospital.com',
      'todayCases': 10,
      'totalCases': 189,
      'availableBeds': 15,
      'totalBeds': 60,
      'occupancyRate': '75%',
      'status': 'Active',
      'avgWaitTime': '30 min',
      'activeStaff': 52,
      'totalStaff': 60,
      'location': 'Civil Lines',
      'contact': '+92 300 8888888',
      'emergencyServices': ['ICU', 'Emergency', 'Burns'],
      'rating': 4.1,
    },
    {
      'name': 'Liaquat National',
      'email': 'liaquat@hospital.com',
      'todayCases': 5,
      'totalCases': 112,
      'availableBeds': 6,
      'totalBeds': 40,
      'occupancyRate': '85%',
      'status': 'Active',
      'avgWaitTime': '22 min',
      'activeStaff': 35,
      'totalStaff': 42,
      'location': 'National Stadium',
      'contact': '+92 300 9999999',
      'emergencyServices': ['ICU', 'Emergency'],
      'rating': 4.5,
    },
  ];

  // Admins data
  final List<Map<String, dynamic>> admins = [
    {
      'name': 'Admin User 1',
      'email': 'admin1@test.com',
      'status': 'Active',
      'approvedToday': 8,
      'rejectedToday': 2,
      'pendingReview': 3,
      'lastActive': '10 min ago',
      'totalApproved': 456,
      'totalRejected': 34,
      'role': 'Senior Admin',
      'joinedDate': 'Jan 2023',
      'permissions': ['Approve', 'Reject', 'Assign', 'View All'],
    },
    {
      'name': 'Admin User 2',
      'email': 'admin2@test.com',
      'status': 'Active',
      'approvedToday': 6,
      'rejectedToday': 1,
      'pendingReview': 0,
      'lastActive': '25 min ago',
      'totalApproved': 312,
      'totalRejected': 28,
      'role': 'Admin',
      'joinedDate': 'Mar 2023',
      'permissions': ['Approve', 'Reject', 'View Assigned'],
    },
    {
      'name': 'Admin User 3',
      'email': 'admin3@test.com',
      'status': 'Inactive',
      'approvedToday': 0,
      'rejectedToday': 0,
      'pendingReview': 0,
      'lastActive': '3 days ago',
      'totalApproved': 189,
      'totalRejected': 15,
      'role': 'Junior Admin',
      'joinedDate': 'Jul 2023',
      'permissions': ['View Assigned'],
    },
  ];

  // Recent system activities
  final List<Map<String, dynamic>> recentActivities = [
    {
      'type': 'incident_reported',
      'user': 'Ahmed Khan',
      'role': 'Citizen',
      'action': 'Reported new incident',
      'details': 'INC247 - Highway accident near Exit 5',
      'time': '5 min ago',
      'icon': Icons.warning,
      'color': Colors.orange,
      'severity': 'High',
    },
    {
      'type': 'incident_approved',
      'user': 'Admin User 1',
      'role': 'Admin',
      'action': 'Approved incident',
      'details': 'INC246 assigned to Rescue 1122',
      'time': '12 min ago',
      'icon': Icons.check_circle,
      'color': Colors.green,
      'severity': 'Normal',
    },
    {
      'type': 'driver_assigned',
      'user': 'Rescue 1122',
      'role': 'Department',
      'action': 'Assigned driver',
      'details': 'Ali Raza assigned to INC245',
      'time': '18 min ago',
      'icon': Icons.local_shipping,
      'color': Colors.blue,
      'severity': 'Normal',
    },
    {
      'type': 'patient_admitted',
      'user': 'Jinnah Hospital',
      'role': 'Hospital',
      'action': 'Patient admitted',
      'details': 'Patient from INC244 admitted to ICU',
      'time': '25 min ago',
      'icon': Icons.local_hospital,
      'color': Colors.red,
      'severity': 'Critical',
    },
    {
      'type': 'incident_resolved',
      'user': 'Fatima Sheikh',
      'role': 'Driver',
      'action': 'Incident resolved',
      'details': 'INC243 successfully completed',
      'time': '32 min ago',
      'icon': Icons.done_all,
      'color': Colors.teal,
      'severity': 'Normal',
    },
  ];

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isLoading ? _buildShimmerLoading() : _buildCurrentTab(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
            'Super Admin Control',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Complete System Management',
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
              onPressed: () => _showNotifications(),
            ),
            if (systemStats['pendingApproval'] > 0)
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
                    '${systemStats['pendingApproval']}',
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
          onPressed: () => _showSystemSettings(),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red[600],
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 0,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Entities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
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
        return _buildUsersTab();
      case 2:
        return _buildDriversTab();
      case 3:
        return _buildEntitiesTab();
      case 4:
        return _buildAnalyticsTab();
      default:
        return Container();
    }
  }

  Widget _buildFloatingActionButton() {
    IconData icon;
    String label;
    VoidCallback onPressed;

    switch (_currentIndex) {
      case 1:
        icon = Icons.person_add;
        label = 'Add User';
        onPressed = () => _showAddDialog('User');
        break;
      case 2:
        icon = Icons.person_add;
        label = 'Add Driver';
        onPressed = () => _showAddDialog('Driver');
        break;
      case 3:
        icon = Icons.add_business;
        label = 'Add Entity';
        onPressed = () => _showAddDialog('Entity');
        break;
      default:
        return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: Colors.red[600],
      icon: Icon(icon),
      label: Text(label),
    );
  }

  // DASHBOARD TAB
  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(seconds: 1));
        setState(() => _isLoading = false);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (systemStats['activeIncidents'] > 5)
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
                            Icons.warning_amber,
                            color: Colors.red[700],
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
                            'High System Activity',
                            style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${systemStats['activeIncidents']} active incidents requiring attention',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.red[700], size: 20),
                  ],
                ),
              ).animate().fadeIn().slide(),
            _buildSystemOverview(),
            const SizedBox(height: 16),
            _buildQuickStatsGrid(),
            const SizedBox(height: 16),
            _buildRolesOverview(),
            const SizedBox(height: 16),
            _buildRecentActivity(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'System Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              _buildTimeFrameSelector(),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.6, // Increased from 1.5 to give more height
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildStatCard(
                'Total Incidents',
                systemStats['totalIncidents'].toString(),
                Icons.warning,
                Colors.purple,
              ),
              _buildStatCard(
                'Today',
                systemStats['todayIncidents'].toString(),
                Icons.today,
                Colors.blue,
              ),
              _buildStatCard(
                'Active Now',
                systemStats['activeIncidents'].toString(),
                Icons.circle,
                Colors.orange,
              ),
              _buildStatCard(
                'Resolved',
                systemStats['resolvedToday'].toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Resources',
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
            crossAxisCount: 3,
            childAspectRatio: 1.2, // Further increased to give even more height
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildMiniStatCard('Users', systemStats['totalUsers'].toString(),
                  Icons.people, Colors.blue),
              _buildMiniStatCard(
                  'Drivers',
                  systemStats['activeDrivers'].toString(),
                  Icons.local_shipping,
                  Colors.green),
              _buildMiniStatCard(
                  'Departments',
                  systemStats['totalDepartments'].toString(),
                  Icons.business,
                  Colors.purple),
              _buildMiniStatCard(
                  'Hospitals',
                  systemStats['totalHospitals'].toString(),
                  Icons.local_hospital,
                  Colors.red),
              _buildMiniStatCard(
                  'Admins',
                  systemStats['totalAdmins'].toString(),
                  Icons.admin_panel_settings,
                  Colors.orange),
              _buildMiniStatCard(
                  'Pending',
                  systemStats['pendingApproval'].toString(),
                  Icons.pending,
                  Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRolesOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Roles Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildRoleCard(
            'Citizens/Reporters',
            users.length,
            users.where((u) => u['status'] == 'Active').length,
            Colors.blue,
            Icons.person,
            'Total reports: ${systemStats['totalReports']}',
          ),
          const SizedBox(height: 8),
          _buildRoleCard(
            'Drivers',
            drivers.length,
            drivers.where((d) => d['status'] != 'OFFLINE').length,
            Colors.green,
            Icons.local_shipping,
            'On duty: ${drivers.where((d) => d['status'] == 'BUSY').length}',
          ),
          const SizedBox(height: 8),
          _buildRoleCard(
            'Departments',
            departments.length,
            departments.where((d) => d['status'] == 'Active').length,
            Colors.purple,
            Icons.business,
            'Active incidents: ${systemStats['activeIncidents']}',
          ),
          const SizedBox(height: 8),
          _buildRoleCard(
            'Hospitals',
            hospitals.length,
            hospitals.where((h) => h['status'] == 'Active').length,
            Colors.red,
            Icons.local_hospital,
            'Today cases: ${hospitals.fold<int>(0, (sum, h) => sum + (h['todayCases'] as int))}',
          ),
          const SizedBox(height: 8),
          _buildRoleCard(
            'Admins',
            admins.length,
            admins.where((a) => a['status'] == 'Active').length,
            Colors.orange,
            Icons.admin_panel_settings,
            'Pending reviews: ${systemStats['pendingApproval']}',
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(String title, int total, int active, Color color,
      IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$active/$total',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Active',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100));
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important: Don't force max size
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8), // Reduced spacing
          Flexible(
            // Allow text to shrink if needed
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2), // Reduced spacing
          Text(
            value,
            style: const TextStyle(
              fontSize: 20, // Reduced from 24
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  // Replace _buildMiniStatCard method with this version:
  Widget _buildMiniStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10), // Further reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important
        children: [
          Icon(icon, color: color, size: 18), // Further reduced icon size
          const SizedBox(height: 4), // Further reduced spacing
          Flexible(
            // Allow text to shrink
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10, // Further reduced font size
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15, // Further reduced from 16
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildTimeFrameSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: _selectedTimeFrame,
        underline: const SizedBox(),
        isDense: true,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[800],
          fontWeight: FontWeight.w600,
        ),
        items: ['Today', 'Week', 'Month', 'Year']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) => setState(() => _selectedTimeFrame = value!),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent System Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentActivities.map((activity) => _buildActivityCard(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['action'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['details'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: activity['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activity['role'],
                        style: TextStyle(
                          color: activity['color'],
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${activity['user']} • ${activity['time']}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
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

  // USERS TAB
  Widget _buildUsersTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Citizens/Reporters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${users.length} total users',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.sort),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              final user = users[index - 1];
              return _buildUserCard(user);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[400]),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor:
              user['status'] == 'Active' ? Colors.green[100] : Colors.grey[300],
          child: Icon(
            Icons.person,
            color: user['status'] == 'Active'
                ? Colors.green[700]
                : Colors.grey[700],
            size: 28,
          ),
        ),
        title: Text(
          user['name'],
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              user['email'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              '${user['reports']} reports • ${user['lastActive']}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: user['status'] == 'Active'
                ? Colors.green[100]
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: user['status'] == 'Active' ? Colors.green : Colors.grey,
            ),
          ),
          child: Text(
            user['status'],
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: user['status'] == 'Active'
                  ? Colors.green[700]
                  : Colors.grey[700],
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Phone', user['phone']),
                _buildDetailRow('Joined', user['joinedDate']),
                _buildDetailRow('Total Reports', user['reports'].toString()),
                _buildDetailRow('Verification', user['verificationStatus']),
                _buildDetailRow('Rating', '${user['rating']} ⭐'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewUserDetails(user),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _manageUser(user),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Manage'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                        ),
                      ),
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

  // DRIVERS TAB
  Widget _buildDriversTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: drivers.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'All Drivers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${drivers.where((d) => d['status'] != 'OFFLINE').length} active drivers',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.sort),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              final driver = drivers[index - 1];
              return _buildDriverCard(driver);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver) {
    Color statusColor;
    switch (driver['status']) {
      case 'BUSY':
        statusColor = Colors.orange;
        break;
      case 'AVAILABLE':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: statusColor.withOpacity(0.2),
              child: Icon(
                Icons.local_shipping,
                color: statusColor,
                size: 28,
              ),
            ),
            if (driver['status'] == 'BUSY')
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          driver['name'],
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${driver['department']} • ${driver['vehicle']}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              '${driver['completedToday']} today • ${driver['totalCompleted']} total',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            driver['status'],
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Email', driver['email']),
                _buildDetailRow('License', driver['license']),
                _buildDetailRow('Department', driver['department']),
                _buildDetailRow('Location', driver['location']),
                _buildDetailRow('Rating', '${driver['rating']} ⭐'),
                _buildDetailRow('Joined', driver['joinedDate']),
                if (driver['currentIncident'] != null)
                  _buildDetailRow(
                      'Current Incident', driver['currentIncident']),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _trackDriver(driver),
                        icon: const Icon(Icons.location_on, size: 18),
                        label: const Text('Track Live'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _manageDriver(driver),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Manage'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                        ),
                      ),
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

  // ENTITIES TAB
  Widget _buildEntitiesTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              labelColor: Colors.red[600],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.red[600],
              tabs: const [
                Tab(text: 'Departments'),
                Tab(text: 'Hospitals'),
                Tab(text: 'Admins'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDepartmentsList(),
                _buildHospitalsList(),
                _buildAdminsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: departments.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Departments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${departments.length} departments active',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        final dept = departments[index - 1];
        return _buildDepartmentCard(dept);
      },
    );
  }

  Widget _buildDepartmentCard(Map<String, dynamic> dept) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.purple[100],
          child: Icon(
            Icons.business,
            color: Colors.purple[700],
            size: 28,
          ),
        ),
        title: Text(
          dept['name'],
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Manager: ${dept['manager']}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              '${dept['activeIncidents']} active • ${dept['drivers']} drivers',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dept['avgResponse'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
            Text(
              'Avg Time',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Email', dept['email']),
                _buildDetailRow('Manager', dept['manager']),
                _buildDetailRow('Contact', dept['managerPhone']),
                _buildDetailRow('Location', dept['location']),
                _buildDetailRow('Total Drivers', '${dept['drivers']}'),
                _buildDetailRow('Available', '${dept['availableDrivers']}'),
                _buildDetailRow('Today Incidents', '${dept['todayIncidents']}'),
                _buildDetailRow('Total Incidents', '${dept['totalIncidents']}'),
                _buildDetailRow('Established', dept['establishedDate']),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewDeptDetails(dept),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _manageDept(dept),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Manage'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                        ),
                      ),
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

  Widget _buildHospitalsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hospitals.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Hospitals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${hospitals.length} hospitals connected',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        final hospital = hospitals[index - 1];
        return _buildHospitalCard(hospital);
      },
    );
  }

  Widget _buildHospitalCard(Map<String, dynamic> hospital) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.red[100],
          child: Icon(
            Icons.local_hospital,
            color: Colors.red[700],
            size: 28,
          ),
        ),
        title: Text(
          hospital['name'],
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              hospital['location'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              '${hospital['availableBeds']}/${hospital['totalBeds']} beds • ${hospital['todayCases']} cases today',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hospital['occupancyRate'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            Text(
              'Occupied',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Email', hospital['email']),
                _buildDetailRow('Contact', hospital['contact']),
                _buildDetailRow('Location', hospital['location']),
                _buildDetailRow('Total Beds', '${hospital['totalBeds']}'),
                _buildDetailRow(
                    'Available Beds', '${hospital['availableBeds']}'),
                _buildDetailRow('Occupancy', hospital['occupancyRate']),
                _buildDetailRow('Staff',
                    '${hospital['activeStaff']}/${hospital['totalStaff']}'),
                _buildDetailRow('Avg Wait', hospital['avgWaitTime']),
                _buildDetailRow('Today Cases', '${hospital['todayCases']}'),
                _buildDetailRow('Total Cases', '${hospital['totalCases']}'),
                _buildDetailRow('Rating', '${hospital['rating']} ⭐'),
                _buildDetailRow('Services',
                    (hospital['emergencyServices'] as List).join(', ')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewHospitalDetails(hospital),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _manageHospital(hospital),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Manage'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                        ),
                      ),
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

  Widget _buildAdminsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: admins.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Admins',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${admins.where((a) => a['status'] == 'Active').length}/${admins.length} admins active',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        final admin = admins[index - 1];
        return _buildAdminCard(admin);
      },
    );
  }

  Widget _buildAdminCard(Map<String, dynamic> admin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: admin['status'] == 'Active'
              ? Colors.orange[100]
              : Colors.grey[300],
          child: Icon(
            Icons.admin_panel_settings,
            color: admin['status'] == 'Active'
                ? Colors.orange[700]
                : Colors.grey[700],
            size: 28,
          ),
        ),
        title: Text(
          admin['name'],
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              admin['role'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              '${admin['approvedToday']} approved today • ${admin['pendingReview']} pending',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: admin['status'] == 'Active'
                ? Colors.green[100]
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: admin['status'] == 'Active' ? Colors.green : Colors.grey,
            ),
          ),
          child: Text(
            admin['status'],
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: admin['status'] == 'Active'
                  ? Colors.green[700]
                  : Colors.grey[700],
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Email', admin['email']),
                _buildDetailRow('Role', admin['role']),
                _buildDetailRow('Joined', admin['joinedDate']),
                _buildDetailRow('Last Active', admin['lastActive']),
                _buildDetailRow('Approved Today', '${admin['approvedToday']}'),
                _buildDetailRow('Rejected Today', '${admin['rejectedToday']}'),
                _buildDetailRow('Pending Review', '${admin['pendingReview']}'),
                _buildDetailRow('Total Approved', '${admin['totalApproved']}'),
                _buildDetailRow('Total Rejected', '${admin['totalRejected']}'),
                _buildDetailRow(
                    'Permissions', (admin['permissions'] as List).join(', ')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewAdminDetails(admin),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _manageAdmin(admin),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Manage'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                        ),
                      ),
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

  // ANALYTICS TAB
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard(
            'Performance Metrics',
            [
              {
                'label': 'Avg Response Time',
                'value': systemStats['avgResponseTime']
              },
              {'label': 'System Uptime', 'value': systemStats['systemUptime']},
              {'label': 'Resolution Rate', 'value': '94.2%'},
              {'label': 'User Satisfaction', 'value': '4.6/5'},
            ],
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildAnalyticsCard(
            'Incident Statistics',
            [
              {
                'label': 'Total Incidents',
                'value': systemStats['totalIncidents'].toString()
              },
              {
                'label': 'Active',
                'value': systemStats['activeIncidents'].toString()
              },
              {
                'label': 'Resolved Today',
                'value': systemStats['resolvedToday'].toString()
              },
              {
                'label': 'Critical',
                'value': systemStats['criticalIncidents'].toString()
              },
            ],
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildAnalyticsCard(
            'Resource Utilization',
            [
              {
                'label': 'Active Drivers',
                'value':
                    '${drivers.where((d) => d['status'] != 'OFFLINE').length}/${drivers.length}'
              },
              {
                'label': 'Busy Drivers',
                'value': drivers
                    .where((d) => d['status'] == 'BUSY')
                    .length
                    .toString()
              },
              {
                'label': 'Available Beds',
                'value':
                    '${hospitals.fold<int>(0, (sum, h) => sum + (h['availableBeds'] as int))}'
              },
              {
                'label': 'Active Departments',
                'value': departments.length.toString()
              },
            ],
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildAnalyticsCard(
            'User Engagement',
            [
              {
                'label': 'Total Users',
                'value': systemStats['totalUsers'].toString()
              },
              {
                'label': 'Active Users',
                'value': users
                    .where((u) => u['status'] == 'Active')
                    .length
                    .toString()
              },
              {
                'label': 'Reports Today',
                'value': systemStats['todayIncidents'].toString()
              },
              {
                'label': 'Pending Approvals',
                'value': systemStats['pendingApproval'].toString()
              },
            ],
            Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildTopPerformers(),
          const SizedBox(height: 16),
          _buildDepartmentComparison(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
      String title, List<Map<String, String>> metrics, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.analytics, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      metric['value']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      metric['label']!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers() {
    final topDrivers = [
      ...drivers
    ]..sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.emoji_events,
                    color: Colors.amber[700], size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Top Performers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topDrivers.take(3).map((driver) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.amber[100],
                      child: Icon(Icons.person,
                          color: Colors.amber[700], size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            driver['department'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.amber[700], size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${driver['rating']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${driver['totalCompleted']} cases',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDepartmentComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.compare, color: Colors.purple[700], size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Department Comparison',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...departments.map((dept) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dept['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${dept['todayIncidents']} today',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: (dept['todayIncidents'] as int) / 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(Colors.purple[400]),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  // Action Methods
  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  child: Icon(Icons.warning, color: Colors.orange[700]),
                ),
                title: const Text('High Activity Alert'),
                subtitle:
                    Text('${systemStats['activeIncidents']} incidents active'),
                trailing: const Text('Now'),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red[100],
                  child: Icon(Icons.notifications, color: Colors.red[700]),
                ),
                title: const Text('Pending Approvals'),
                subtitle:
                    Text('${systemStats['pendingApproval']} waiting review'),
                trailing: const Text('5m ago'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSystemSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Security Settings'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Backup & Restore'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('System Updates'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New $type'),
        content: Text('Form to add new $type would appear here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _viewUserDetails(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${user['name']}')),
    );
  }

  void _manageUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage ${user['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Suspend User'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete User'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _trackDriver(Map<String, dynamic> driver) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tracking ${driver['name']} live location')),
    );
  }

  void _manageDriver(Map<String, dynamic> driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage ${driver['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assign Incident'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Mark Offline'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewDeptDetails(Map<String, dynamic> dept) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${dept['name']}')),
    );
  }

  void _manageDept(Map<String, dynamic> dept) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage ${dept['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Details'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Drivers'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('View Statistics'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewHospitalDetails(Map<String, dynamic> hospital) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${hospital['name']}')),
    );
  }

  void _manageHospital(Map<String, dynamic> hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage ${hospital['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Details'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.hotel),
              title: const Text('Update Bed Status'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('View Statistics'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewAdminDetails(Map<String, dynamic> admin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${admin['name']}')),
    );
  }

  void _manageAdmin(Map<String, dynamic> admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage ${admin['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Change Permissions'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Suspend Admin'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
