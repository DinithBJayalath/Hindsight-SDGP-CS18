import 'package:flutter/material.dart';
import 'package:frontend/widgets/login_style.dart';
import 'package:frontend/widgets/login_textfield.dart';
import 'package:frontend/widgets/logo_tile.dart';
import 'package:frontend/widgets/signin_botton.dart';
import 'package:frontend/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Instantiate AuthService

  final AuthService _authService = AuthService();
  void signUserIn() async {
    await _authService
        .login(); // Call login method when user taps the sign-in button
  }

  @override
  Widget build(BuildContext context) {
    return LoginStyle(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 50),
            // const Icon(
            //   Icons.favorite,
            //   size: 100,
            // ),
            const SizedBox(height: 90),
            const Text(
              'Sign in',
              style: TextStyle(
                  color: Color.fromARGB(255, 172, 112, 255),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            LoginTextField(
              controller: usernameController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            LoginTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // sign in button
            SigninButton(
              onTap: signUserIn, // Trigger login on tap
            ),

            const SizedBox(
              height: 40,
            ),

            // add divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 137, 137, 137),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      ' Or ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 137, 137, 137),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 137, 137, 137),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            //Google ,Twitter , Apple buttons
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Google button
                LogoTile(imagePath: 'assets/images/google.png'),

                SizedBox(
                  width: 60,
                ),

                //apple button
                LogoTile(imagePath: 'assets/images/apple.png'),

                SizedBox(
                  width: 60,
                ),

                //Twitter button
                LogoTile(imagePath: 'assets/images/x.png'),
              ],
            ),

            // Don’t have an account? Sign up
            const SizedBox(
              height: 40,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don’t have an account? '),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color.fromARGB(255, 172, 112, 255),
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
