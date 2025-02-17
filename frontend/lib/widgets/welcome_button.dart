import 'package:flutter/material.dart';

class WellcomeButton extends StatelessWidget {
  const WellcomeButton({super.key, this.buttonText, this.onTap});
  final String? buttonText;
  final Widget? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (e) => onTap!,
            ),
          );
        }, // route to pages
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 140, 211, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            buttonText!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ));
  }
}
