import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:incident_reporting_app/screens/auth/login_screen.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  // Hardcoded special keys for different roles
  static const Map<String, String> _roleKeys = {
    'admin': '12345678',
    'department': '12345678',
    'hospital': '12345678',
    'super_admin': '12345678',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Role'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              NavigationService.navigateWithReplacement(RouteNames.login),
        ),
      ),
      body: Stack(
        children: [
          // Background pattern image
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: AssetImage('assets/images/bg_pattern.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
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
                        builder: (context) => LoginScreen(),
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
                  isSecured: true,
                  onTap: () => _showSecurityKeyDialog(context, 'admin'),
                )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slide(begin: const Offset(0.5, 0)),
                _RoleCard(
                  icon: Icons.people,
                  title: 'Department',
                  color: Colors.orange,
                  isSecured: true,
                  onTap: () => _showSecurityKeyDialog(context, 'department'),
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
                        builder: (context) => LoginScreen(),
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
                  isSecured: true,
                  onTap: () => _showSecurityKeyDialog(context, 'hospital'),
                )
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slide(begin: const Offset(-0.5, 0)),
                _RoleCard(
                  icon: Icons.security,
                  title: 'Super Admin',
                  color: Colors.indigo,
                  isSecured: true,
                  onTap: () => _showSecurityKeyDialog(context, 'super_admin'),
                )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .slide(begin: const Offset(0.5, 0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSecurityKeyDialog(BuildContext context, String role) {
    final TextEditingController keyController = TextEditingController();
    bool isObscured = true;
    int attemptCount = 0;
    const int maxAttempts = 3;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Security Icon with Animation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.security,
                        size: 48,
                        color: Colors.red.shade600,
                      ),
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(delay: 1000.ms, duration: 2000.ms),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Security Access Required',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Enter special key for ${_getRoleDisplayName(role)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Security Key Input
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade50,
                      ),
                      child: TextField(
                        controller: keyController,
                        obscureText: isObscured,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter security key',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.grey.shade600,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),

                    if (attemptCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Invalid key. Attempts remaining: ${maxAttempts - attemptCount}',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final enteredKey = keyController.text.trim();
                              if (_validateKey(role, enteredKey)) {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  attemptCount++;
                                });

                                if (attemptCount >= maxAttempts) {
                                  Navigator.of(context).pop();
                                  _showMaxAttemptsDialog(context);
                                } else {
                                  keyController.clear();
                                  // Add shake animation for wrong key
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Invalid security key'),
                                      backgroundColor: Colors.red.shade600,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMaxAttemptsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: Icon(
            Icons.block,
            color: Colors.red.shade600,
            size: 48,
          ),
          title: const Text(
            'Access Denied',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Maximum attempts exceeded. Please contact your system administrator for access.',
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _validateKey(String role, String enteredKey) {
    return _roleKeys[role] == enteredKey;
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'department':
        return 'Department';
      case 'hospital':
        return 'Hospital';
      case 'super_admin':
        return 'Super Admin';
      default:
        return role;
    }
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool isSecured;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.isSecured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top section with icon and optional security badge
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Main icon container
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
                  // Security badge positioned relative to icon
                  if (isSecured)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Title
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Small indicator for secured roles
              if (isSecured) ...[
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Secured',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
