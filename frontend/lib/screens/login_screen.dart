import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
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
          builder: (context) => HomeScreen(userInfo: userInfo),
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
      Map<String, dynamic> userInfo = {};
      if (result.containsKey('id_token')) {
        userInfo = Jwt.parseJwt(result['id_token']);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userInfo: userInfo),
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
      Map<String, dynamic> userInfo = {};
      if (result.containsKey('id_token')) {
        userInfo = Jwt.parseJwt(result['id_token']);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userInfo: userInfo),
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
      Map<String, dynamic> userInfo = {};
      if (result.containsKey('id_token')) {
        userInfo = Jwt.parseJwt(result['id_token']);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userInfo: userInfo),
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 90),
            const Text(
              'Login',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
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
            // Sign in button for username/password login
            SigninButton(
              onTap: signUserIn,
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 20),
            // Social login buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google button
                GestureDetector(
                  onTap: loginWithGoogle,
                  child: const LogoTile(imagePath: 'assets/images/google.png'),
                ),
                const SizedBox(width: 60),
                // Apple button
                GestureDetector(
                  onTap: loginWithApple,
                  child: const LogoTile(imagePath: 'assets/images/apple.png'),
                ),
                const SizedBox(width: 60),
                // Twitter button
                GestureDetector(
                  onTap: loginWithTwitter,
                  child: const LogoTile(imagePath: 'assets/images/x.png'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Sign up prompt
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don’t have an account? '),
                SizedBox(width: 4),
                Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
