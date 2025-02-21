import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String auth0Domain =
      'dev-hindsight.uk.auth0.com'; // Example: 'dev-xyz.auth0.com'
  static const String clientId =
      'FFAKXDh8vl0RHvZcSp2em9UABrI3a746'; // Found in Auth0 Dashboard

  /// Function to send a password reset email
  static Future<bool> sendPasswordResetEmail(String email) async {
    const String url = 'https://$auth0Domain/dbconnections/change_password';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'client_id': clientId,
      'email': email,
      'connection':
          'Username-Password-Authentication', // Default database connection
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
