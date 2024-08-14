import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/booking_repository.dart';
import 'package:flutter_application_3/screens/booking_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center =
      const LatLng(8.5241, 76.9366); // Thiruvananthapuram, Kerala

  final Set<Marker> _markers = {};
  LocationData? _currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('id-1'),
          position: _center,
          infoWindow: const InfoWindow(
            title: 'San Francisco',
            snippet: 'An interesting city',
          ),
        ),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    final Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        log('Location services are disabled.');
        return;
      }
    }

    // Check if location permissions are granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        log('Location permissions are denied.');
        return;
      }
    }

    // Get current location
    try {
      _currentLocation = await location.getLocation();
      log('Current location: Latitude: ${_currentLocation!.latitude}, Longitude: ${_currentLocation!.longitude}');
      _animateToUser();
    } catch (e) {
      log('Could not get location: ${e.toString()}');
    }
  }

  void _animateToUser() {
    if (_currentLocation != null) {
      final CameraPosition cameraPosition = CameraPosition(
        target:
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 14.0,
      );

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('user-location'),
            position: LatLng(
                _currentLocation!.latitude!, _currentLocation!.longitude!),
            infoWindow: const InfoWindow(
              title: 'You are here',
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map with Marker'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 50,
            left: 10, // Move button to the left side
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
