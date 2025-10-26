// ============================================
// LOGIN SCREEN
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:incident_reporting_app/screens/auth/register_screen.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Dummy credentials for testing
  final Map<String, Map<String, String>> _dummyCredentials = {
    // Citizen
    'citizen@test.com': {'password': '123456', 'role': 'citizen'},

    // Driver
    'driver@test.com': {'password': '123456', 'role': 'driver'},

    // Hospital
    'hospital@test.com': {'password': '123456', 'role': 'hospital'},

    // Admin
    'admin@test.com': {'password': '123456', 'role': 'admin'},

    // Department
    'department@test.com': {'password': '123456', 'role': 'department'},

    // Super Admin
    'superadmin@test.com': {'password': '123456', 'role': 'super_admin'},
  };

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Check credentials
      if (_dummyCredentials.containsKey(email) &&
          _dummyCredentials[email]!['password'] == password) {
        final role = _dummyCredentials[email]!['role']!;

        setState(() => _isLoading = false);

        // Navigate based on role
        _navigateBasedOnRole(role);
      } else {
        setState(() => _isLoading = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _navigateBasedOnRole(String role) {
    print('🔍 DEBUG: Navigating with role: $role');

    String routeName;

    switch (role) {
      case 'citizen':
        print('✅ Going to UserReportScreen');
        routeName = RouteNames.userReportScreen;
        break;
      case 'admin':
        print('✅ Going to AdminDashboard');
        routeName = RouteNames.adminDashboard;
        break;
      case 'department':
        print('✅ Going to DepartmentDashboard');
        routeName = RouteNames.departmentScreen;
        break;
      case 'driver':
        print('✅ Going to DriverScreen');
        routeName = RouteNames.driverScreen;
        break;
      case 'hospital':
        print('✅ Going to MainHospitalScreen');
        routeName = RouteNames.hospitalScreen;
        break;
      case 'super_admin':
        print('✅ Going to SuperAdminScreen');
        routeName = RouteNames.superAdminScreen;
        print('🔍 Route name: $routeName'); // ADD THIS
        break;
      default:
        print('❌ Unknown role');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown role')),
        );
        return;
    }

    // Use named routes for navigation
    NavigationService.navigateWithReplacement(routeName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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

          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                      ),
                    ).animate().fadeIn(duration: 500.ms).scale(),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.5, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.5, end: 0),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms)
                        .slideX(begin: -0.5, end: 0),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms)
                        .slideX(begin: -0.5, end: 0),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: const Text(
                              'Sign In',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 500.ms)
                            .slideY(begin: 0.5, end: 0),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 500.ms)
                        .slideY(begin: 0.5, end: 0),
                    TextButton(
                      onPressed: () {
                        // Show dummy credentials
                        _showCredentialsDialog();
                      },
                      child: const Text('Forgot password?'),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms)
                        .slideY(begin: 0.5, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCredentialsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Credentials'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Use these credentials for testing:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildCredentialItem('Citizen', 'citizen@test.com'),
              _buildCredentialItem('Driver', 'driver@test.com'),
              _buildCredentialItem('Hospital', 'hospital@test.com'),
              _buildCredentialItem('Admin', 'admin@test.com'),
              _buildCredentialItem('Department', 'department@test.com'),
              _buildCredentialItem('Super Admin', 'superadmin@test.com'),
              const SizedBox(height: 10),
              const Text(
                'Password for all: 123456',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
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

  Widget _buildCredentialItem(String role, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$role: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              email,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
