import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:frontend/widgets/login_style.dart';
import 'package:frontend/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginStyle(
        child: Stack(
          children: [
            // Background Image Positioned at Exact Location
            Positioned(
              top: 80, // Adjust this value to move the logo up/down
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png', // Replace with your logo's asset path
                  width: 240, // Adjust the logo size as needed
                  height: 240, // Adjust the logo size as needed
                ),
              ),
            ),

            // "Hindsight" Text Positioned at Exact Location
            Positioned(
              top: 310, // Adjust this value to move the text up/down
              left: 0,
              right: 0,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Hindsight',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 48.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // "Log in" Button Positioned at Exact Location
            const Positioned(
              top: 500,
              left: 50, // Adjust horizontal position
              right: 50, // Adjust horizontal position
              child: WellcomeButton(
                buttonText: 'Log in',
                color: Color.fromARGB(255, 140, 211, 255),
                textColor: Colors.black,
                onTap: LoginScreen(),
              ),
            ),

            // "Sign up" Button Positioned at Exact Location
            // "Sign Up" Button Positioned Below "Log in"
            const Positioned(
              top: 580, // Adjust this value to position the "Sign Up" button
              left: 50,
              right: 50,
              child: WellcomeButton(
                buttonText: 'Sign Up',
                color: Color.fromARGB(
                    255, 140, 211, 255), // You can customize the color
                textColor: Colors.black,
                onTap: SignUpScreen(), // Navigate to the SignUpScreen
              ),
            ),
          ],
        ),
      ),
    );
  }
}
