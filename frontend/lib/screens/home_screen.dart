import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const HomeScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    // Use 'name' if available; otherwise, fallback to 'User'
    final userName = userInfo['name'] ?? 'User';
    final userEmail = userInfo['email'] ?? 'Not available';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color.fromARGB(255, 172, 112, 255),
        actions: [
          // Logout button in the app bar.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Create an instance of AuthService and call logout
              AuthService authService = AuthService();
              await authService.logout();
              // Navigate to the welcome (login) screen after logout.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, $userName!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Email: $userEmail",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
