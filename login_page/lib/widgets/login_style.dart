import 'package:flutter/material.dart';

class login_style extends StatelessWidget {
  const login_style({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 248, 228, 252),
          ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}
