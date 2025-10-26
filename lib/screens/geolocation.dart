// import 'package:geolocator/geolocator.dart';
//
// Future<void> _getLocation() async {
//   setState(() {
//     _isLoading = true;
//   });
//
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   // Check if location services are enabled
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     setState(() {
//       _location = 'Location services are disabled.';
//       _isLoading = false;
//     });
//     return;
//   }
//
//   // Check permission status
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       setState(() {
//         _location = 'Location permissions are denied';
//         _isLoading = false;
//       });
//       return;
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     setState(() {
//       _location =
//       'Location permissions are permanently denied. Please enable in settings.';
//       _isLoading = false;
//     });
//     return;
//   }
//
//   // Get the current position
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//
//   setState(() {
//     _location = '${position.latitude}, ${position.longitude}';
//     _isLoading = false;
//   });
// }
