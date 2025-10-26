import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();
  final _ambulanceServiceController = TextEditingController();
  final _licenseController = TextEditingController();
  final _vehicleRegController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _experienceController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedRole = 'citizen'; // Default to citizen
  String? _selectedBloodGroup;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  bool get isCitizen => _selectedRole == 'citizen';
  bool get isDriver => _selectedRole == 'driver';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _ambulanceServiceController.dispose();
    _licenseController.dispose();
    _vehicleRegController.dispose();
    _emergencyContactController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Fill in your details to get started',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Role Selection
                  Text(
                    'Select Your Role',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Citizen'),
                          value: 'citizen',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                              // Clear driver-specific fields
                              _ambulanceServiceController.clear();
                              _licenseController.clear();
                              _vehicleRegController.clear();
                              _emergencyContactController.clear();
                              _experienceController.clear();
                              _selectedBloodGroup = null;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: _selectedRole == 'citizen'
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Driver'),
                          value: 'driver',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() => _selectedRole = value!);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: _selectedRole == 'driver'
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter your email';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // CNIC (All users)
                  TextFormField(
                    controller: _cnicController,
                    decoration: const InputDecoration(
                      labelText: 'CNIC Number (13 digits)',
                      prefixIcon: Icon(Icons.credit_card),
                      hintText: '1234567890123',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter CNIC';
                      if (value.length != 13)
                        return 'CNIC must be exactly 13 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Phone Number (All users)
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      hintText: '03001234567',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter phone number';
                      if (value.length < 11) return 'Enter valid phone number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Driver-specific fields
                  if (isDriver) ...[
                    // Ambulance Service
                    TextFormField(
                      controller: _ambulanceServiceController,
                      decoration: const InputDecoration(
                        labelText: 'Ambulance Service/Company',
                        prefixIcon: Icon(Icons.local_hospital),
                        hintText: 'e.g., Edhi Ambulance Service',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter ambulance service name'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Driving License
                    TextFormField(
                      controller: _licenseController,
                      decoration: const InputDecoration(
                        labelText: 'Driving License Number',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter license number'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Vehicle Registration
                    TextFormField(
                      controller: _vehicleRegController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Registration Number',
                        prefixIcon: Icon(Icons.directions_car),
                        hintText: 'e.g., ABC-123',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter vehicle registration number'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Years of Experience
                    TextFormField(
                      controller: _experienceController,
                      decoration: const InputDecoration(
                        labelText: 'Years of Driving Experience',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter years of experience';
                        }
                        int? years = int.tryParse(value);
                        if (years == null || years < 1) {
                          return 'Enter valid experience (minimum 1 year)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Blood Group
                    DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      decoration: const InputDecoration(
                        labelText: 'Blood Group',
                        prefixIcon: Icon(Icons.bloodtype),
                      ),
                      items: _bloodGroups.map((bloodGroup) {
                        return DropdownMenuItem(
                          value: bloodGroup,
                          child: Text(bloodGroup),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedBloodGroup = value);
                      },
                      validator: (value) =>
                          value == null ? 'Select blood group' : null,
                    ),
                    const SizedBox(height: 16),

                    // Emergency Contact
                    TextFormField(
                      controller: _emergencyContactController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Number',
                        prefixIcon: Icon(Icons.contact_phone),
                        hintText: '03001234567',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter emergency contact';
                        }
                        if (value.length < 11) {
                          return 'Enter valid contact number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter password';
                      if (value.length < 6) {
                        return 'Minimum 6 characters required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _register,
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() => _isLoading = false);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful as $_selectedRole!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to login screen
        Navigator.pop(context);
      }
    }
  }
}
