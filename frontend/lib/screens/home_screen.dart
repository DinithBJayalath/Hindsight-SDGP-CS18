import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const HomeScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Fetch the complete user profile from our backend
  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      // Get profile from backend
      final profile = await _authService.getUserProfile();

      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading user profile: $e");
      setState(() => _isLoading = false);
    }
  }

  void _logout() async {
    await _authService.logout();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final String name =
        _userProfile['name'] ?? widget.userInfo['name'] ?? 'User';

    final String email = _userProfile['email'] ??
        widget.userInfo['email'] ??
        'No email available';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Name: $name',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 18),
                  ),
                  // Display more user profile information as needed
                ],
              ),
            ),
    );
  }
}
