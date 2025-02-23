import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailValidatorService {
  static const String auth0Domain =
      "YOUR_AUTH0_DOMAIN"; // e.g., dev-xxxxxx.us.auth0.com
  static const String auth0ClientId =
      "YOUR_AUTH0_CLIENT_ID"; // Your Auth0 Client ID
  static const String auth0ClientSecret =
      "YOUR_AUTH0_CLIENT_SECRET"; // Your Auth0 Client Secret
  static const String auth0Audience = "https://YOUR_AUTH0_DOMAIN/api/v2/";

  /// **Get Auth0 Management API Token**
  static Future<String?> _getAuth0Token() async {
    final response = await http.post(
      Uri.parse("https://$auth0Domain/oauth/token"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "client_id": auth0ClientId,
        "client_secret": auth0ClientSecret,
        "audience": auth0Audience,
        "grant_type": "client_credentials"
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["access_token"];
    } else {
      return null;
    }
  }

  /// **Check if an email is registered in Auth0**
  static Future<bool> isEmailRegistered(String email) async {
    final token = await _getAuth0Token();
    if (token == null) return false;

    final response = await http.get(
      Uri.parse("https://$auth0Domain/api/v2/users-by-email?email=$email"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> users = jsonDecode(response.body);
      return users.isNotEmpty; // If user exists, return true
    }
    return false;
  }
}
