import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/booking_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FetchAllServicesRemoteService _fetchAllServicesRemoteService =
      FetchAllServicesRemoteService();

  bool _isLoading = false;
  String _responseMessage = "";

  Future<void> _fetchServices() async {
    setState(() {
      _isLoading = true;
      _responseMessage = "";
    });

    try {
      var response =
          await _fetchAllServicesRemoteService.fetchAllServiceDetails();
      setState(() {
        _responseMessage = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _responseMessage = "Failed to fetch services";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Services API'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _fetchServices,
                    child: const Text('Fetch Services'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _responseMessage.isEmpty
                        ? "Press the button to fetch services"
                        : _responseMessage,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
