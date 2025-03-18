import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String auth0Domain = dotenv.env['AUTH0_DOMAIN'] ?? "";
  final String clientId = dotenv.env['AUTH0_CLIENT_ID'] ?? "";
  final String audience = dotenv.env['AUTH0_AUDIENCE'] ?? "";
  final String backendUrl = dotenv.env['API_URL'] ?? "";
  final String clientSecret = dotenv.env['AUTH0_CLIENT_SECRET'] ?? "";

  final _storage = const FlutterSecureStorage();

  // Username/Password login method
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      // First, authenticate with Auth0
      final auth0Response = await http.post(
        Uri.parse("https://$auth0Domain/oauth/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "grant_type": "password",
          "client_id": clientId,
          "username": username,
          "password": password,
          "audience": audience,
          "scope": "openid profile email offline_access",
          "connection": "Username-Password-Authentication",
        }),
      );

      if (auth0Response.statusCode == 200) {
        final data = jsonDecode(auth0Response.body);

        // Store tokens securely
        await _storage.write(key: "access_token", value: data['access_token']);
        if (data.containsKey('refresh_token')) {
          await _storage.write(
              key: "refresh_token", value: data['refresh_token']);
        }

        // Validate the token with our backend
        await _validateTokenWithBackend(data['access_token']);

        return data;
      } else {
        print("Login failed: ${auth0Response.body}");
        return null;
      }
    } catch (e) {
      print("Login exception: $e");
      return null;
    }
  }

  // Validate token with our Nest.js backend
  Future<bool> _validateTokenWithBackend(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$backendUrl/auth/validate-token"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        print("Token validated successfully with backend");
        // Optionally store user info from backend
        final userData = jsonDecode(response.body);
        await _storage.write(key: "user_data", value: jsonEncode(userData));
        return true;
      } else {
        print("Backend token validation failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Backend validation exception: $e");
      return false;
    }
  }

  // Get user profile from backend
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      String? token = await _storage.read(key: "access_token");
      String? storedEmail = await _storage.read(key: "user_email");

      if (token == null) {
        print("No access token found");
        return {};
      }

      // First try getting profile from backend
      final response = await http.get(
        Uri.parse("$backendUrl/auth/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      Map<String, dynamic> profileData = {};

      if (response.statusCode == 200) {
        final rawData = jsonDecode(response.body);

        // Extract data from response
        profileData = {
          'id': rawData['id'] ?? rawData['_id'],
          'email': rawData['email'],
          'name': rawData['name'],
          'picture': rawData['picture'],
          'isVerified': rawData['isVerified'],
          'profile': rawData['profile'],
          'auth0Id': rawData['auth0Id'] ?? rawData['sub'],
        };
      } else if (response.statusCode == 401) {
        print("Token expired, attempting refresh...");
        // Token expired, try to refresh
        final refreshed = await refreshToken();
        if (refreshed != null) {
          // Retry with new token
          return await getUserProfile();
        }
      }

      // If email is missing, try to get it from jwt token
      if (!profileData.containsKey('email') || profileData['email'] == null) {
        // Try stored email first
        if (storedEmail != null) {
          profileData['email'] = storedEmail;
        } else {
          // Try to get from token
          try {
            final decodedToken = Jwt.parseJwt(token);
            if (decodedToken.containsKey('email')) {
              final tokenEmail = decodedToken['email'];
              profileData['email'] = tokenEmail;
              // Store for future use
              await _storage.write(key: "user_email", value: tokenEmail);
            }
          } catch (e) {
            print("Error decoding token: $e");
          }
        }
      }

      // Debug logging
      return profileData;
    } catch (e) {
      print("Get profile exception: $e");
      return {};
    }
  }

  // Check if token is expired
  Future<bool> isTokenExpired() async {
    String? accessToken = await _storage.read(key: "access_token");
    if (accessToken == null) return true;
    try {
      final decodedToken = Jwt.parseJwt(accessToken);
      final expiryTime = decodedToken['exp'];
      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
      return expiryTime == null || expiryTime < currentTime;
    } catch (e) {
      print("Error decoding JWT: $e");
      return true;
    }
  }

  // Refresh token function
  Future<Map<String, dynamic>?> refreshToken() async {
    bool expired = await isTokenExpired();
    if (!expired) return null;
    print("Refreshing access token...");
    return await _refreshAccessToken();
  }

  Future<Map<String, dynamic>?> _refreshAccessToken() async {
    String? refreshToken = await _storage.read(key: "refresh_token");
    if (refreshToken == null) return null;
    try {
      final response = await http.post(
        Uri.parse("https://$auth0Domain/oauth/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "grant_type": "refresh_token",
          "client_id": clientId,
          "refresh_token": refreshToken,
          "scope": "openid profile email offline_access",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: "access_token", value: data['access_token']);
        // Validate the new token with our backend
        await _validateTokenWithBackend(data['access_token']);
        print("Token refreshed successfully!");
        return data;
      } else {
        print("Failed to refresh token: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Refresh token exception: $e");
      return null;
    }
  }

  // Sign up function
  Future<Map<String, dynamic>?> signUp(
      String fullName, String email, String password) async {
    try {
      final auth0Response = await http.post(
        Uri.parse("https://$auth0Domain/dbconnections/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "client_id": clientId,
          "email": email,
          "password": password,
          "connection": "Username-Password-Authentication",
          "name": fullName,
          "user_metadata": {
            "full_name": fullName,
          },
        }),
      );

      if (auth0Response.statusCode == 200) {
        final data = jsonDecode(auth0Response.body);
        print("Sign Up successful: $data");

        // Automatically log in the user after signup
        return await login(email, password);
      } else {
        print("Sign Up failed: ${auth0Response.body}");
        return null;
      }
    } catch (e) {
      print("Sign up exception: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: "access_token");
    await _storage.delete(key: "refresh_token");
    await _storage.delete(key: "user_data");
    print("User logged out.");
  }

  // Delete account from Auth0 and backend
  Future<bool> deleteAccount() async {
    try {
      String? token = await _storage.read(key: "access_token");
      if (token == null) {
        print("Cannot delete account: No access token found");
        return false;
      }

      // Call backend endpoint to delete user
      final response = await http.delete(
        Uri.parse("$backendUrl/auth/delete-account"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        print("Account deleted successfully");
        // Clear local storage
        await logout();
        return true;
      } else if (response.statusCode == 401) {
        // Token might be expired, try refreshing and retrying
        print("Token expired, attempting to refresh");
        final refreshed = await refreshToken();

        if (refreshed != null) {
          // Get new token and retry deletion
          token = await _storage.read(key: "access_token");
          if (token != null) {
            print("Retrying account deletion with refreshed token");
            final retryResponse = await http.delete(
              Uri.parse("$backendUrl/auth/delete-account"),
              headers: {
                "Authorization": "Bearer $token",
                "Content-Type": "application/json"
              },
            );

            print(
                "Retry response: ${retryResponse.statusCode} ${retryResponse.body}");

            if (retryResponse.statusCode == 200) {
              print("Account deleted successfully after token refresh");
              await logout();
              return true;
            }
          }
        }
        print("Failed to delete account after token refresh");
        return false;
      } else {
        print(
            "Failed to delete account: ${response.statusCode} ${response.body}");

        // Always clear local storage for these errors - user can't fix them
        if (response.statusCode >= 500) {
          print("Backend error encountered, logging out user anyway");
          await logout();
          return false;
        }

        return false;
      }
    } catch (e) {
      print("Delete account exception: $e");
      return false;
    }
  }
}
