import 'dart:developer';
import 'package:dio/dio.dart';

class FetchAllServicesRemoteService {
  final String _link = "http://10.0.2.2:3000/api/worker/"; // Android

  final Dio dio = Dio();

  Future<Response<dynamic>> fetchAllServiceDetails() async {
    log("on fetch all service in dio");
    try {
      String? token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2YjljMjQzYWQzZGJjYzJhNTdkOGVhNCIsImVtYWlsIjoic2FuZndhbkBnbWFpbC5jb20iLCJyb2xlIjoid29ya2VyIiwibmFtZSI6IlNhZndhbiIsImlhdCI6MTcyMzYyODg1NSwiZXhwIjoxNzI2MjIwODU1fQ.11EFwC-TB9iBFN13pA-hPMW38VgZccXH7Bz-ydch9ps';

      var response = await dio.get(
        "${_link}getBookings",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'userId': null,
          'status': 'pending',
          'workerId': null,
          'service': 'Wipping',
        },
      );
      log("success");
      return response;
    } catch (e) {
      if (e is DioException) {
        log("Error response data: ${e.response?.data}");
        log("Error response headers: ${e.response?.headers}");
        log("Error response status code: ${e.response?.statusCode}");
      }
      log("Error fetch all service: $e");
      throw Exception("Failed to fetch all service");
    }
  }
}
