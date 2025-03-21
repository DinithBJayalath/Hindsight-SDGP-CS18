import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/email_verification_service.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/widgets/agreements_popup.dart';
import 'package:frontend/widgets/login_style.dart';
import 'package:frontend/widgets/login_textfield.dart';
//import 'package:frontend/widgets/logo_tile.dart';
import 'package:frontend/widgets/signin_botton.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/popup_message.dart';
import 'package:frontend/widgets/verification_code_input.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:email_validator/email_validator.dart';

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
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final AuthService _authService = AuthService();

  /// Shows a dialog for email verification with 6-digit code input
  Future<bool> showVerificationDialog(String email) async {
    String enteredCode = '';
    bool verified = false;
    // This loading state will be managed by the dialog itself
    bool dialogIsLoading = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Email Verification"),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Enter the 6-digit verification code sent to your email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  VerificationCodeInput(
                    onCompleted: (code) {
                      enteredCode = code;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: dialogIsLoading
                        ? null
                        : () async {
                            // Use the dialog's own setState
                            setDialogState(() {
                              dialogIsLoading = true;
                            });

                            await EmailVerificationService
                                .sendVerificationEmail(email);

                            // Only update state if the dialog is still showing
                            if (dialogContext.mounted) {
                              setDialogState(() {
                                dialogIsLoading = false;
                              });

                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Verification code resent to your email"),
                                ),
                              );
                            }
                          },
                    child: const Text("Resend Code"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: dialogIsLoading
                    ? null
                    : () {
                        Navigator.of(dialogContext).pop();
                      },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: dialogIsLoading
                    ? null
                    : () async {
                        // Use the dialog's own setState
                        setDialogState(() {
                          dialogIsLoading = true;
                        });

                        try {
                          verified = await EmailVerificationService.verifyCode(
                              email, enteredCode);
                        } catch (e) {
                          verified = false;
                          print("Error during verification: $e");
                        }

                        // Only update the UI if the dialog is still showing
                        if (dialogContext.mounted) {
                          setDialogState(() {
                            dialogIsLoading = false;
                          });

                          if (verified) {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(
                                  content: Text("Verification successful")),
                            );
                          } else {
                            PopupMessage.show(
                              dialogContext,
                              "Invalid verification code. Please try again.",
                              isSuccess: false,
                            );
                          }
                        }
                      },
                child: dialogIsLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Verify"),
              ),
            ],
          );
        },
      ),
    );

    return verified;
  }

  /// Handles sign-up via email/password.
  void signUpUser() async {
    if (!agreedToTerms) {
      PopupMessage.show(
        context,
        "Please agree to Terms & Conditions",
        isSuccess: false,
      );
      return;
    }

    String fullName = fullNameController.text;
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      PopupMessage.show(context, "Please fill in all fields", isSuccess: false);
      return;
    }

    if (!EmailValidator.validate(email)) {
      PopupMessage.show(context, "Please enter a valid email address",
          isSuccess: false);
      return;
    }

    if (password != confirmPassword) {
      PopupMessage.show(context, "Passwords do not match", isSuccess: false);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Check if email already exists
      bool emailExists = await ProfileService.checkEmailExists(email);

      if (!mounted) return;

      if (emailExists) {
        PopupMessage.show(
          context,
          "An account with this email already exists. Please use a different email or try logging in.",
          isSuccess: false,
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // First, send verification email
      await EmailVerificationService.sendVerificationEmail(email);

      if (!mounted) return;

      // Show verification dialog and get result
      bool codeVerified = await showVerificationDialog(email);

      if (!mounted) return;

      if (!codeVerified) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // If code is verified, proceed with signup
      final result = await _authService.signUp(fullName, email, password);

      if (!mounted) return;

      if (result != null) {
        // Since the signup method no longer automatically logs in the user,
        // we need to explicitly call login after successful signup

        // Add a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign up successful! Logging you in..."),
          ),
        );

        // After successful signup, log the user in
        final loginResult = await _authService.login(email, password);

        if (!mounted) return;

        if (loginResult != null) {
          // Decode the token to get user info
          Map<String, dynamic> userInfo = {};
          if (loginResult.containsKey('id_token')) {
            userInfo = Jwt.parseJwt(loginResult['id_token']);
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          PopupMessage.show(context, "Login failed. Please try manually.",
              isSuccess: false);
        }
      } else {
        PopupMessage.show(context, "Sign up failed. Please try again.",
            isSuccess: false);
      }
    } catch (e) {
      if (!mounted) return;

      PopupMessage.show(
          context, "An error occurred during signup: ${e.toString()}",
          isSuccess: false);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
            // Confirm Password field with visibility toggle
            Stack(
              alignment: Alignment.centerRight,
              children: [
                LoginTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: !_isConfirmPasswordVisible,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color.fromARGB(255, 137, 137, 137),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ],
            ),
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
                        builder: (dialogContext) => AgreementsPopup(
                          onAccept: () {
                            // User accepts the terms: simply close the dialog.
                            Navigator.of(dialogContext).pop();
                          },
                          onDecline: () {
                            // User declines the terms: reset the checkbox and close the dialog.
                            setState(() {
                              agreedToTerms = false;
                            });
                            Navigator.of(dialogContext).pop();
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
              onTap: isLoading ? null : signUpUser,
              buttonText: isLoading ? 'Processing...' : 'Create Account',
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Do you have an account? ',
                  style: TextStyle(
                    color: Color.fromARGB(159, 21, 18, 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign in',
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
    );
  }
}
