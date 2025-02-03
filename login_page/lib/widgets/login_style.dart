import 'package:flutter/material.dart';

class login_style extends StatelessWidget {
  const login_style({super.key, required this.child});
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
