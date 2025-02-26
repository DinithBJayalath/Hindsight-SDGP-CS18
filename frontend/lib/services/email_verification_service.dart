import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailVerificationService {
  static final String baseUrl =
      dotenv.env['API_URL'] ?? 'http://localhost:3000';

  /// Send verification email and get a 6-digit code
  static Future<String?> sendVerificationEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/email-verification/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        // For security reasons, the actual code is not returned from the backend
        // The code is sent directly to the user's email
        return null; // Return null as we'll ask the user to check their email
      } else {
        print('Failed to send verification email: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending verification email: $e');
      return null;
    }
  }

  /// Verify the code entered by the user
  static Future<bool> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/email-verification/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        print('Failed to verify code: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error verifying code: $e');
      return false;
    }
  }
}
