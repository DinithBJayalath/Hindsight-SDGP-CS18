import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  // Social Login: Google
  Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(scopes: ['openid', 'email', 'profile']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        print(
            "Google idToken is null. Please check your GoogleSignIn configuration.");
        return null;
      }

      // Exchange with Auth0
      final auth0Response = await http.post(
        Uri.parse("https://$auth0Domain/oauth/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
          "client_id": clientId,
          "subject_token": googleAuth.idToken!,
          "subject_token_type": "urn:ietf:params:oauth:token-type:id_token",
          "scope": "openid profile email offline_access",
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
        print("Google login failed: ${auth0Response.body}");
        return null;
      }
    } catch (e) {
      print("Google login exception: $e");
      return null;
    }
  }

/*
  // Social Login: Apple
  Future<Map<String, dynamic>?> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final auth0Response = await http.post(
        Uri.parse("https://$auth0Domain/oauth/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
          "client_id": clientId,
          "subject_token": credential.identityToken,
          "subject_token_type": "urn:ietf:params:oauth:token-type:id_token",
          "scope": "openid profile email offline_access",
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
        print("Apple login failed: ${auth0Response.body}");
        return null;
      }
    } catch (e) {
      print("Apple login exception: $e");
      return null;
    }
  }

  // Social Login: Twitter
  Future<Map<String, dynamic>?> loginWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'YOUR_TWITTER_API_KEY',
        apiSecretKey: 'YOUR_TWITTER_API_SECRET_KEY',
        redirectURI:
            'com.frontend://dev-hindsight.uk.auth0.com/android/com.frontend/callback',
      );

      final authResult = await twitterLogin.login();
      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final auth0Response = await http.post(
          Uri.parse("https://$auth0Domain/oauth/token"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
            "client_id": clientId,
            "subject_token": authResult.authToken,
            "subject_token_type":
                "urn:ietf:params:oauth:token-type:access_token",
            "scope": "openid profile email offline_access",
          }),
        );

        if (auth0Response.statusCode == 200) {
          final data = jsonDecode(auth0Response.body);

          // Store tokens securely
          await _storage.write(
              key: "access_token", value: data['access_token']);
          if (data.containsKey('refresh_token')) {
            await _storage.write(
                key: "refresh_token", value: data['refresh_token']);
          }

          // Validate the token with our backend
          await _validateTokenWithBackend(data['access_token']);

          return data;
        } else {
          print("Twitter login failed: ${auth0Response.body}");
          return null;
        }
      } else {
        print("Twitter login canceled or failed: ${authResult.status}");
        return null;
      }
    } catch (e) {
      print("Twitter login exception: $e");
      return null;
    }
  }
*/
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
      if (token == null) return {};

      final response = await http.get(
        Uri.parse("$backendUrl/auth/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to get user profile: ${response.body}");
        if (response.statusCode == 401) {
          // Token expired, try to refresh
          final refreshed = await refreshToken();
          if (refreshed != null) {
            // Retry with new token
            return await getUserProfile();
          }
        }
        return {};
      }
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
      if (token == null) return false;

      // Get Management API Token first
      final tokenResponse = await http.post(
        Uri.parse("https://$auth0Domain/oauth/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "client_id": clientId,
          "client_secret": clientSecret,
          "audience": audience,
          "grant_type": "client_credentials"
        }),
      );

      if (tokenResponse.statusCode != 200) {
        print("Failed to get management token: ${tokenResponse.body}");
        return false;
      }

      final managementToken = jsonDecode(tokenResponse.body)['access_token'];
      final userId = Jwt.parseJwt(token)['sub'];

      // Delete user from Auth0
      final auth0Response = await http.delete(
        Uri.parse("https://$auth0Domain/api/v2/users/$userId"),
        headers: {
          "Authorization": "Bearer $managementToken",
          "Content-Type": "application/json"
        },
      );

      if (auth0Response.statusCode != 204) {
        print("Failed to delete account from Auth0: ${auth0Response.body}");
        return false;
      }

      // Delete profile from backend
      final backendResponse = await http.delete(
        Uri.parse("$backendUrl/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (backendResponse.statusCode != 200) {
        print("Failed to delete profile from backend: ${backendResponse.body}");
      }

      // Clear local storage
      await logout();
      return true;
    } catch (e) {
      print("Delete account exception: $e");
      return false;
    }
  }
}
