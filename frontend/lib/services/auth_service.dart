import 'package:auth0_flutter/auth0_flutter.dart';

class AuthService {
  final Auth0 auth0 = Auth0(
    'dev-hindsight.uk.auth0.com', // Replace with your Auth0 domain
    'FFAKXDh8vl0RHvZcSp2em9UABrI3a746', // Replace with your Auth0 client ID
  );

  // Log in method
  Future<void> login() async {
    try {
      final credentials =
          await auth0.webAuthentication(scheme: "com.frontend").login();
      print('Access Token: ${credentials.accessToken}');
      // Handle successful login (e.g., navigate to home screen)
    } catch (e) {
      print('Login failed: $e');
      // Handle error (show a message to the user)
    }
  }

  // Log out method
  Future<void> logout() async {
    try {
      await auth0.webAuthentication(scheme: "com.frontend").logout();
      print('Logged out');
      // Handle successful logout (e.g., navigate back to login screen)
    } catch (e) {
      print('Logout failed: $e');
      // Handle error
    }
  }
}
