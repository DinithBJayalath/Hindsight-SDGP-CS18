import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hindsight/screens/login_screen.dart';
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
      print("Attempting to connect to $auth0Domain...");

      // First, authenticate with Auth0
      final auth0Response = await http
          .post(
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
      )
          .timeout(const Duration(seconds: 60), onTimeout: () {
        print("Connection timeout to Auth0");
        throw Exception(
            "Connection timeout. Please check your internet connection.");
      });

      if (auth0Response.statusCode == 200) {
        final data = jsonDecode(auth0Response.body);

        // Store tokens securely
        await _storage.write(key: "access_token", value: data['access_token']);
        if (data.containsKey('refresh_token')) {
          await _storage.write(
              key: "refresh_token", value: data['refresh_token']);
        }

        // Extract user info from the ID token if available
        if (data.containsKey('id_token')) {
          try {
            final idTokenData = Jwt.parseJwt(data['id_token']);
            if (idTokenData.containsKey('sub')) {
              await _storage.write(key: "auth0_id", value: idTokenData['sub']);
            }
            if (idTokenData.containsKey('name')) {
              await _storage.write(
                  key: "user_name", value: idTokenData['name']);
            }
            if (idTokenData.containsKey('email')) {
              await _storage.write(
                  key: "user_email", value: idTokenData['email']);
            }
          } catch (e) {
            print("Error extracting data from ID token: $e");
          }
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
        // Store user info from backend
        final userData = jsonDecode(response.body);
        await _storage.write(key: "user_data", value: jsonEncode(userData));

        // Store auth0Id, name and email separately for easier access
        if (userData.containsKey('auth0Id') || userData.containsKey('sub')) {
          final auth0Id = userData['auth0Id'] ?? userData['sub'];
          await _storage.write(key: "auth0_id", value: auth0Id);
        }

        if (userData.containsKey('name')) {
          await _storage.write(key: "user_name", value: userData['name']);
        }

        if (userData.containsKey('email')) {
          await _storage.write(key: "user_email", value: userData['email']);
        }

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
          'profile': rawData['profile'],
          'auth0Id': rawData['auth0Id'] ?? rawData['sub'],
        };

        // Store auth0Id and name for easier access
        if (profileData.containsKey('auth0Id') &&
            profileData['auth0Id'] != null) {
          await _storage.write(key: "auth0_id", value: profileData['auth0Id']);
        }

        if (profileData.containsKey('name') && profileData['name'] != null) {
          await _storage.write(key: "user_name", value: profileData['name']);
        }
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

            // Also try to get auth0Id and name from token
            if (decodedToken.containsKey('sub')) {
              profileData['auth0Id'] = decodedToken['sub'];
              await _storage.write(key: "auth0_id", value: decodedToken['sub']);
            }

            if (decodedToken.containsKey('name')) {
              profileData['name'] = decodedToken['name'];
              await _storage.write(
                  key: "user_name", value: decodedToken['name']);
            }
          } catch (e) {
            print("Error decoding token: $e");
          }
        }
      }

      // If still missing data, try getting it from Auth0 directly
      if (!profileData.containsKey('email') ||
          profileData['email'] == null ||
          !profileData.containsKey('name') ||
          profileData['name'] == null ||
          !profileData.containsKey('auth0Id') ||
          profileData['auth0Id'] == null) {
        print("Still missing user data, trying Auth0 userinfo endpoint...");
        try {
          final auth0Response = await http.get(
            Uri.parse("https://$auth0Domain/userinfo"),
            headers: {
              "Authorization": "Bearer $token",
            },
          );

          if (auth0Response.statusCode == 200) {
            final auth0Data = jsonDecode(auth0Response.body);

            if (auth0Data['email'] != null) {
              profileData['email'] = auth0Data['email'];
              await _storage.write(
                  key: "user_email", value: auth0Data['email']);
            }

            // Update other missing fields if available
            if (auth0Data['name'] != null) {
              profileData['name'] ??= auth0Data['name'];
              await _storage.write(key: "user_name", value: auth0Data['name']);
            }

            if (auth0Data['sub'] != null) {
              profileData['auth0Id'] ??= auth0Data['sub'];
              await _storage.write(key: "auth0_id", value: auth0Data['sub']);
            }

            profileData['picture'] ??= auth0Data['picture'];
          }
        } catch (e) {
          print("Error getting data from Auth0 userinfo: $e");
        }
      }

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
    await _storage.delete(key: "user_name");
    await _storage.delete(key: "auth0_id");

    print("User logged out.");
  }

  // Delete account from Auth0 and backend
  Future<bool> deleteAccount(BuildContext context) async {
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

        // Navigate to login screen and restart app
        if (context.mounted) {
          restartAppAfterDeletion(context);
        }

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

              // Navigate to login screen and restart app
              if (context.mounted) {
                restartAppAfterDeletion(context);
              }

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

  // Navigate to login screen after account deletion and restart the app
  void restartAppAfterDeletion(BuildContext context) {
    // Clear all routes and navigate to login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );

    // Optional: If you want to perform a more complete restart,
    // you can use SystemNavigator to exit the app - user will need to reopen it
    // This simulates a complete app restart
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemNavigator.pop(); // This will close the app
    });
  }
}
