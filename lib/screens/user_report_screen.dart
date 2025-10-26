import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class UserReportScreen extends StatefulWidget {
  const UserReportScreen({super.key});

  @override
  State<UserReportScreen> createState() => _UserReportScreenState();
}

class _UserReportScreenState extends State<UserReportScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _location = "Loading your location...";
  final DateTime _currentTime = DateTime.now();
  String _selectedDepartment = "Traffic Police";
  final List<String> _departments = [
    "Traffic Police",
    "Rescue 1122",
    "Police",
    "Fire Brigade",
    "Medical Emergency"
  ];
  bool _isLoading = false;
  StreamSubscription<Position>? _positionStream;


  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = 'Location services are disabled.';
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = 'Location permissions are denied';
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location =
        'Location permissions are permanently denied. Please enable in settings.';
        _isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = '${position.latitude}, ${position.longitude}';
      _isLoading = false;
    });
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _location = '${position.latitude}, ${position.longitude}';
      });
    });
  }

  void _stopLocationUpdates() {
    _positionStream?.cancel();
  }


  Future<void> _getImage() async {
    try {
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
      }

      if (cameraStatus.isGranted) {
        setState(() {
          _isLoading = true;
        });

        final pickedFile = await _picker
            .pickImage(
              source: ImageSource.camera,
              maxWidth: 1800,
              maxHeight: 1800,
              imageQuality: 90,
            )
            .timeout(const Duration(seconds: 30));

        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No image was selected'),
            ),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to take photos'),
          ),
        );
      }
    } on TimeoutException {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera operation timed out'),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accessing camera: ${e.toString()}'),
        ),
      );
    }
  }



  @override
  void initState() {
    super.initState();
    _getLocation();         // Immediate location fetch
    _startLocationUpdates();  }

  @override
  void dispose() {
    _stopLocationUpdates();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService.navigateWithReplacement(
                RouteNames.roleSelection),
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap your content in a body parameter
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Report an Emergency',
                  textStyle: Theme.of(context).textTheme.displayMedium,
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
            ),
            const SizedBox(height: 20),
            _buildStepCard(
              context,
              step: 1,
              title: 'Capture Incident Photo',
              child: GestureDetector(
                onTap: _getImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Tap to take photo',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(_image!, fit: BoxFit.cover),
                            ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildStepCard(
              context,
              step: 2,
              title: 'Verify Location & Time',
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('Location'),
                    subtitle: _isLoading
                        ? const LinearProgressIndicator()
                        : Text(_location),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _getLocation,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.access_time,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('Time'),
                    subtitle: Text(
                      '${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')} - ${_currentTime.day}/${_currentTime.month}/${_currentTime.year}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildStepCard(
              context,
              step: 3,
              title: 'Select Department',
              child: DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _departments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDepartment = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: 'Select Department',
                  prefixIcon: Icon(
                    Icons.people,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please capture an image first'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                _showSubmissionDialog();
              },
              child: const Text(
                'Submit Report',style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(BuildContext context,
      {required int step, required String title, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$step',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Report Submitted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your incident report has been submitted for admin approval. You will be notified once it is processed.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
