import 'package:flutter/material.dart';
import 'package:login_page/widgets/login_style.dart';
import 'package:login_page/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: login_style(
        child: Stack(
          children: [
            // "Hindsight" Text Positioned at Exact Location
            Positioned(
              top: 200, // Adjust this value to move the text up/down
              left: 0,
              right: 0,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Hindsight',
                    style: TextStyle(
                      color: Color.fromARGB(255, 172, 112, 255),
                      fontSize: 48.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // "Log in" Button Positioned at Exact Location
            const Positioned(
              top: 650,
              bottom: 100, // Adjust this value to move the button up/down
              left: 50, // Adjust horizontal position
              right: 50, // Adjust horizontal position
              child: welcome_button(
                buttonText: 'Log in',
                color: Color.fromARGB(255, 172, 112, 255),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
