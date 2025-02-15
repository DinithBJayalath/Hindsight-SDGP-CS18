import 'package:flutter/material.dart';

class LoginStyle extends StatelessWidget {
  const LoginStyle({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 228, 252),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 248, 228, 252),
          ),
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
