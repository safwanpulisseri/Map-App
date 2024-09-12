import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator

class MapScreenTwo extends StatefulWidget {
  const MapScreenTwo({super.key});

  @override
  createState() => _MapScreenTwoState();
}

class _MapScreenTwoState extends State<MapScreenTwo> {
  bool _isPermissionRequesting = false;

  Future<void> _checkLocationPermission(BuildContext context) async {
    if (_isPermissionRequesting) return; // Prevent multiple requests
    setState(() {
      _isPermissionRequesting = true;
    });

    PermissionStatus locationStatus = await Permission.location.request();
    setState(() {
      _isPermissionRequesting = false;
    });

    if (locationStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      // Print the current location details to the console
      print('Current Latitude: $latitude');
      print('Current Longitude: $longitude');

      // Optionally, you can also show a map screen for users to select a location
      final locationController = TextEditingController();
      final locationData = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MapScreen(locationController: locationController),
        ),
      );

      if (locationData != null) {
        double selectedLatitude = locationData['lat'];
        double selectedLongitude = locationData['long'];

        // Print the selected location details to the console
        print('Selected Latitude: $selectedLatitude');
        print('Selected Longitude: $selectedLongitude');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location updated successfully!')),
        );
      }
    } else if (locationStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is denied!')),
      );
    } else if (locationStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Permission Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _checkLocationPermission(context),
          child: const Text('Check Location Permission'),
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.locationController});
  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Your Location'),
      ),
      body: OpenStreetMapSearchAndPick(
        buttonWidth: 130,
        zoomInIcon: Icons.zoom_in_sharp,
        zoomOutIcon: Icons.zoom_out,
        locationPinIconColor: Colors.blueGrey,
        locationPinTextStyle: const TextStyle(
            color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold),
        buttonColor: Colors.blue,
        buttonText: 'Pick Location',
        buttonTextStyle: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        onPicked: (pickedData) {
          final data = {
            'lat': pickedData.latLong.latitude,
            'long': pickedData.latLong.longitude,
          };
          locationController.text = pickedData.address['state_district'] ?? '';
          Navigator.pop(context, data); // Return the location data
        },
      ),
    );
  }
}
