import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const ProfileScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    // Retrieve user data from userInfo map
    final String name = userInfo['name'] ?? 'Unknown';
    final String email = userInfo['email'] ?? 'No email provided';
    // You can display more details if available in userInfo

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color.fromARGB(255, 172, 112, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: $name", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Email: $email", style: const TextStyle(fontSize: 18)),
            // Add more fields here as needed
          ],
        ),
      ),
    );
  }
}
