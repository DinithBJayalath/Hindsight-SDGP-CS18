import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/email_verification_service.dart';
import 'package:frontend/widgets/agreements_popup.dart';
import 'package:frontend/widgets/login_style.dart';
import 'package:frontend/widgets/login_textfield.dart';
import 'package:frontend/widgets/logo_tile.dart';
import 'package:frontend/widgets/signin_botton.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/popup_message.dart';
import 'package:jwt_decode/jwt_decode.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool agreedToTerms = false;

  final AuthService _authService = AuthService();

  /// Shows a dialog for email verification.
  Future<bool> showVerificationDialog(String expectedCode) async {
    TextEditingController codeController = TextEditingController();
    bool verified = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Email Verification"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the verification code sent to your email."),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Verification Code",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Compare entered code with the expected code.
              if (codeController.text.trim() == expectedCode) {
                verified = true;
                Navigator.of(context).pop();
              } else {
                verified = false;
                Navigator.of(context).pop();
              }
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );

    return verified;
  }

  /// Handles sign-up via email/password.
  void signUpUser() async {
    if (!agreedToTerms) {
      if (mounted) {
        PopupMessage.show(
          context,
          "Please agree to Terms & Conditions",
          isSuccess: false,
        );
      }
      return;
    }

    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      if (mounted) {
        PopupMessage.show(context, "Please fill in all fields",
            isSuccess: false);
      }
      return;
    }

    if (password != confirmPassword) {
      if (mounted) {
        PopupMessage.show(context, "Passwords do not match", isSuccess: false);
      }
      return;
    }

    final result = await _authService.signUp(fullName, email, password);
    if (!mounted) return;

    if (result != null) {
      await Future.delayed(const Duration(milliseconds: 500));

      // Send verification email and get the expected code.
      String verificationCode =
          await EmailVerificationService.sendVerificationEmail(email);
      // Show the verification popup.
      bool codeVerified = await showVerificationDialog(verificationCode);

      if (!codeVerified) {
        PopupMessage.show(
            context, "Incorrect verification code. Please try again.",
            isSuccess: false);
        return;
      }

      //If code verified, apply login
      final loginResult = await _authService.login(email, password);

      if (!mounted) return;
      if (loginResult != null) {
        // Decode the token to get user info
        Map<String, dynamic> userInfo = {};
        if (loginResult.containsKey('id_token')) {
          userInfo = Jwt.parseJwt(loginResult['id_token']);
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userInfo: userInfo),
            ),
          );
        }
      } else {
        PopupMessage.show(context, "Login failed. Please try manually.",
            isSuccess: false);
      }
    } else {
      PopupMessage.show(context, "Sign up failed. Please try again.",
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
      child: SingleChildScrollView(
        //padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            const Text(
              'Register',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            LoginTextField(
              controller: fullNameController,
              hintText: 'Full Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            LoginTextField(
              controller: emailController,
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
            LoginTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            //const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 5),
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (value) {
                    setState(() {
                      agreedToTerms = value ?? false;
                    });
                    // When the user ticks the box, show the agreements popup.
                    if (agreedToTerms) {
                      showDialog(
                        context: context,
                        builder: (context) => AgreementsPopup(
                          onAccept: () {
                            // User accepts the terms: simply close the dialog.
                            Navigator.of(context).pop();
                          },
                          onDecline: () {
                            // User declines the terms: reset the checkbox and close the dialog.
                            setState(() {
                              agreedToTerms = false;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    }
                  },
                ),
                const Text('I agree with Terms & Conditions'),
              ],
            ),
            const SizedBox(height: 20),
            SigninButton(
              onTap: signUpUser,
              buttonText: 'Create Account',
            ),
            const SizedBox(height: 30),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _authService.loginWithGoogle(),
                  child: const LogoTile(imagePath: 'assets/images/google.png'),
                ),
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: () => _authService.loginWithApple(),
                  child: const LogoTile(imagePath: 'assets/images/apple.png'),
                ),
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: () => _authService.loginWithTwitter(),
                  child: const LogoTile(imagePath: 'assets/images/x.png'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
