import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResetPasswordService {
  static String get auth0Domain => dotenv.env['AUTH0_DOMAIN'] ?? '';
  static String get clientId => dotenv.env['AUTH0_CLIENT_ID'] ?? '';

  /// Function to send a password reset email
  static Future<bool> sendPasswordResetEmail(String email) async {
    final String url = 'https://$auth0Domain/dbconnections/change_password';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'client_id': clientId,
      'email': email,
      'connection': 'Username-Password-Authentication',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Password reset email sent successfully.');
        return true;
      } else {
        print('Failed to send password reset email: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error sending password reset email: $error');
      return false;
    }
  }
}
