import 'package:flutter/material.dart';

class welcome_button extends StatelessWidget {
  const welcome_button(
      {super.key, this.buttonText, this.color, this.textColor});
  final String? buttonText;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {}, // route to pages
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: color!,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            buttonText!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: textColor!,
            ),
          ),
        ));
  }
}
