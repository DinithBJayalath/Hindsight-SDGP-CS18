import 'package:flutter/material.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:frontend/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _defaultHome = const WelcomeScreen(); // Default starting screen
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    setState(() {
      _isLoading = true;
    });
    final isLoggedIn = !(await _authService.isTokenExpired());

    if (isLoggedIn) {
      _defaultHome = const ProfileScreen(userInfo: {});
    } else {
      _defaultHome = const WelcomeScreen();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hindsight",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(userInfo: {}),
      },
      home: _isLoading
          ? const Scaffold(
              body: Center(
                  child: CircularProgressIndicator())) // Loading indicator
          : _defaultHome,
    );
  }
}
