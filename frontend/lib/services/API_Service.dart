import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // Base URL of your NestJS backend
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

  ApiService({required this.baseUrl});

  // Method to send POST request with authentication
  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> data,
      {bool requireAuth = false}) async {
    try {
      // Build headers with content type
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      // Add authentication token if required
      if (requireAuth) {
        final token = await _storage.read(key: 'access_token');
        if (token == null) {
          throw Exception('Authentication required');
        }
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      // Check if request was successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to post data: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    }
  }

  // Method to send GET request with optional authentication
  Future<Map<String, dynamic>> getData(String endpoint,
      {Map<String, dynamic>? queryParams, bool requireAuth = false}) async {
    try {
      // Build headers with content type
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      // Add authentication token if required
      if (requireAuth) {
        final token = await _storage.read(key: 'access_token');
        if (token == null) {
          throw Exception('Authentication required');
        }
        headers['Authorization'] = 'Bearer $token';
      }

      // parsing the parameters passed to the url
      final uri = Uri.parse('$baseUrl/$endpoint').replace(
        queryParameters:
            queryParams?.map((key, value) => MapEntry(key, value.toString())),
      );
      final response = await http.get(
        uri,
        headers: headers,
      );

      // Check if request was successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    }
  }
}
