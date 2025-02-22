import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  final Function()? onTap;

  const SigninButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 172, 112, 255),
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Center(
          child: Text(
            'Sign in',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
