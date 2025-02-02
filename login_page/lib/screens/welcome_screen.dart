import 'package:flutter/material.dart';
import 'package:login_page/widgets/login_style.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return login_style(
        child: Column(
      children: [
        Flexible(
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
                      text: 'wellcome Back!\n',
                      style: TextStyle(
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
        Flexible(child: Text('Wellcome')),
      ],
    ));
  }
}
