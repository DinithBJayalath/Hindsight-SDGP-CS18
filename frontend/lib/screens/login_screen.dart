import 'package:flutter/material.dart';
import 'package:frontend/screens/forgot_password_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:frontend/widgets/login_style.dart';
import 'package:frontend/widgets/login_textfield.dart';
import 'package:frontend/widgets/logo_tile.dart';
import 'package:frontend/widgets/signin_botton.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/popup_message.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void signUserIn() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      PopupMessage.show(context, "Please fill in both username and password",
          isSuccess: false);
      return;
    }

    final result = await _authService.login(username, password);
    if (!mounted) return;

    if (result != null) {
      PopupMessage.show(context, "Login successful", isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Map<String, dynamic> userInfo = {};
      if (result.containsKey('id_token')) {
        userInfo = Jwt.parseJwt(result['id_token']);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userInfo: userInfo),
        ),
      );
    } else {
      PopupMessage.show(context, "Login failed. Please check your credentials.",
          isSuccess: false);
    }
  }

  // Social login for Google
  void loginWithGoogle() async {
    final result = await _authService.loginWithGoogle();
    if (!mounted) return;
    if (result != null) {
      PopupMessage.show(context, "Google Login successful", isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Map<String, dynamic> userInfo = {};
      if (result.containsKey('id_token')) {
        userInfo = Jwt.parseJwt(result['id_token']);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userInfo: userInfo),
        ),
      );
    } else {
      PopupMessage.show(context, "Google Login failed.", isSuccess: false);
    }
  }

  // Social login for Apple
  void loginWithApple() async {
    final result = await _authService.loginWithApple();
    if (!mounted) return;
    if (result != null) {
      PopupMessage.show(context, "Apple Login successful", isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Map<String, dynamic> userInfo = {};
      if (result.containsKey('id_token')) {
        userInfo = Jwt.parseJwt(result['id_token']);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userInfo: userInfo),
        ),
      );
    } else {
      PopupMessage.show(context, "Apple Login failed.", isSuccess: false);
    }
  }

  // Social login for Twitter
  void loginWithTwitter() async {
    final result = await _authService.loginWithTwitter();
    if (!mounted) return;
    if (result != null) {
      PopupMessage.show(context, "Twitter Login successful", isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Map<String, dynamic> userInfo = {};
      if (result.containsKey('id_token')) {
        userInfo = Jwt.parseJwt(result['id_token']);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userInfo: userInfo),
        ),
      );
    } else {
      PopupMessage.show(context, "Twitter Login failed.", isSuccess: false);
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
                LoginTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
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
                const SizedBox(height: 30),
                // Social login buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google button
                    GestureDetector(
                      onTap: loginWithGoogle,
                      child:
                          const LogoTile(imagePath: 'assets/images/google.png'),
                    ),
                    const SizedBox(width: 60),
                    // Apple button
                    GestureDetector(
                      onTap: loginWithApple,
                      child:
                          const LogoTile(imagePath: 'assets/images/apple.png'),
                    ),
                    const SizedBox(width: 60),
                    // Twitter button
                    GestureDetector(
                      onTap: loginWithTwitter,
                      child: const LogoTile(imagePath: 'assets/images/x.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Sign up prompt: "Don't have an account? Sign up" with clickable, underlined sign-up text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don’t have an account? ',
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
