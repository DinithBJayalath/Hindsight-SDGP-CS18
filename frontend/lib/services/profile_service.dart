import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';
  static const _storage = FlutterSecureStorage();

  // Get profile by email (uses the new email endpoint)
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
        Uri.parse('$baseUrl/profile/email/$email'),
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

  // Get profile by user ID
  static Future<Map<String, dynamic>?> getProfileByUserId(String userId) async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        print('Error: No access token found');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profile/user/$userId'),
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

  // Update profile using profile ID
  static Future<Map<String, dynamic>?> updateProfile(
      String profileId, Map<String, dynamic> profileData) async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('No access token found');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/profile/$profileId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  // Create profile with user ObjectId
  static Future<Map<String, dynamic>?> createProfile(
      Map<String, dynamic> profileData) async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('No access token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to create profile');
      }
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  static Future<bool> checkEmailExists(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/check-email/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['exists'] == true;
      }
      return false;
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }
}
