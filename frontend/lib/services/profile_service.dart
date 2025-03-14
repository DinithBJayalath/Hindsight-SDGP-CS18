import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>?> getProfile(String? email) async {
    if (email == null) {
      print('Error: Email is null');
      return null;
    }

    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        print('Error: No access token found');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profile/$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      print('Failed to get profile: ${response.body}');
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  static Future<bool> updateProfile(
      String? email, Map<String, dynamic> profileData) async {
    if (email == null) {
      print('Error: Email is null');
      return false;
    }

    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        print('Error: No access token found');
        return false;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/profile/$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  static Future<bool> createProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        print('Error: No access token found');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating profile: $e');
      return false;
    }
  }

  static Future<bool> deleteProfile(String? email) async {
    if (email == null) {
      print('Error: Email is null');
      return false;
    }

    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        print('Error: No access token found');
        return false;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/profile/$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting profile: $e');
      return false;
    }
  }
}
