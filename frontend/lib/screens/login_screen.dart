import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import '../services/auth_service.dart';
import '../widgets/login_style.dart';
import '../widgets/login_textfield.dart';
import '../widgets/popup_message.dart';
import '../widgets/signin_botton.dart';
import 'package:flutter/material.dart';

import 'package:jwt_decode/jwt_decode.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final AuthService _authService = AuthService();

  void signUserIn() async {
    String username = usernameController.text.trim();
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      PopupMessage.show(context, "Please fill in both username and password",
          isSuccess: false);
      return;
    }

    if (!EmailValidator.validate(username)) {
      PopupMessage.show(context, "Please enter a valid email address",
          isSuccess: false);
      return;
    }

    final result = await _authService.login(username, password);
    if (!mounted) return;

    if (result != null) {
      try {
        // Extract user info from id_token
        Map<String, dynamic> userInfo = {};
        if (result.containsKey('id_token')) {
          userInfo = Jwt.parseJwt(result['id_token']);
          print("User info from token: $userInfo"); // Debug log
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful")),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } catch (e) {
        print("Error during post-login process: $e");
        PopupMessage.show(context,
            "Login successful but encountered an error. Please try again.",
            isSuccess: false);
      }
    } else {
      PopupMessage.show(context, "Invalid email or password. Please try again.",
          isSuccess: false);
    }
  }

  @override
  void initState() {
    super.initState();
    _authService.refreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return LoginStyle(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                LoginTextField(
                  controller: usernameController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Password field with visibility toggle
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    LoginTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: !_isPasswordVisible,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(255, 137, 137, 137),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Sign in button for username/password login
                SigninButton(
                  onTap: signUserIn,
                  buttonText: 'Log In',
                ),
                // Left-aligned "Forgot password?" text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 27.0,
                        bottom: 5,
                        top: 5), // Adjust this value as needed
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to forgot password screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(159, 21, 18, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Divider
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
                // const SizedBox(height: 30),
                // // Social login buttons row
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // Google button
                //     GestureDetector(
                //       //onTap: loginWithGoogle,
                //       child:
                //           const LogoTile(imagePath: 'assets/images/google.png'),
                //     ),
                //     const SizedBox(width: 60),
                //     // Apple button
                //     GestureDetector(
                //       //onTap: loginWithApple,
                //       child:
                //           const LogoTile(imagePath: 'assets/images/apple.png'),
                //     ),
                //     const SizedBox(width: 60),
                //     // Twitter button
                //     GestureDetector(
                //       //onTap: loginWithTwitter,
                //       child: const LogoTile(imagePath: 'assets/images/x.png'),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 15),
                // Sign up prompt: "Don't have an account? Sign up" with clickable, underlined sign-up text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Color.fromARGB(159, 21, 18, 18),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(159, 21, 18, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
