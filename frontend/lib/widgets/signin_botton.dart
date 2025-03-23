import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  final Function()? onTap;
  final String? buttonText;
  final Widget? child;

  const SigninButton({
    super.key,
    required this.onTap,
    this.buttonText,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 140, 211, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: child ??
              Text(
                buttonText ?? '',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        ),
      ),
    );
  }
}
