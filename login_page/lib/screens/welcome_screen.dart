import 'package:flutter/material.dart';
import 'package:login_page/widgets/login_style.dart';
import 'package:login_page/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return login_style(
        child: Column(
      children: [
        Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Hindsight !\n',
                          style: TextStyle(
                            color: Color.fromARGB(231, 0, 0, 0),
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                          )),
                      TextSpan(
                        text: '\n Enter to login / logout',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        const Flexible(
          flex: 0,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                Expanded(
                  child: welcome_button(
                    buttonText: 'Sign in',
                    color: Colors.transparent,
                    textColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: welcome_button(
                    buttonText: 'Sign Up',
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
