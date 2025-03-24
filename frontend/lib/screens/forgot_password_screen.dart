import 'login_screen.dart';
import 'reset_email_sent_screen.dart';
import '../services/profile_service.dart';
import '../services/reset_password.dart';
import '../widgets/login_style.dart';
import '../widgets/login_textfield.dart';
import '../widgets/popup_message.dart';
import '../widgets/signin_botton.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  void sendPasswordReset() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      PopupMessage.show(
        context,
        "Please enter your email",
        isSuccess: false,
      );
      return;
    }

    if (!EmailValidator.validate(email)) {
      PopupMessage.show(
        context,
        "Please enter a valid email address",
        isSuccess: false,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if email exists in database
      bool emailExists = await ProfileService.checkEmailExists(email);

      if (!mounted) return;

      if (!emailExists) {
        PopupMessage.show(
          context,
          "No account found with this email address",
          isSuccess: false,
        );
        setState(() => _isLoading = false);
        return;
      }

      bool success = await ResetPasswordService.sendPasswordResetEmail(email);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset email sent successfully"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResetEmailSentScreen(email: email)),
        );
      } else {
        PopupMessage.show(
          context,
          "Failed to send password reset email. Please try again.",
          isSuccess: false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      PopupMessage.show(
        context,
        "An error occurred. Please try again later.",
        isSuccess: false,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginStyle(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text more to the right
          children: [
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.only(left: 30), // Push text to the right
              child: Text(
                "Forgot your password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.only(left: 30), // Push text to the right
              child: Text(
                "Enter your registered email below to receive password reset instruction",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              // Center the image
              child: Container(
                height: 230,
                width: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(0, 224, 224, 224),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/forgotpassword.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            LoginTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SigninButton(
                    onTap: sendPasswordReset,
                    buttonText: 'Send',
                  ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 190),
              child: Center(
                // Keep "Remember Password?" centered
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Remember Password? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "LogIn",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
