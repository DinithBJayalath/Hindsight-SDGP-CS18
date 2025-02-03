import 'package:flutter/material.dart';
import 'package:login_page/widgets/login_style.dart';
import 'package:login_page/widgets/login_textfield.dart';
import 'package:login_page/widgets/welcome_button.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login_screen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return login_style(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Icon(
              Icons.favorite,
              size: 100,
            ),
            const SizedBox(height: 50),
            const Text(
              'Sign in',
              style: TextStyle(
                  color: Color.fromARGB(255, 172, 112, 255),
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            LoginTextField(
              controller: usernameController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            LoginTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(
              height: 10,
            ),
            const welcome_button(
              buttonText: 'Sign in',
              color: Color.fromARGB(255, 172, 112, 255),
              textColor: Colors.white,
              onTap: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}
