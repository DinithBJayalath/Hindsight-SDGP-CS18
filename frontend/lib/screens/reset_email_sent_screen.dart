import 'login_screen.dart';
import '../services/reset_password.dart';
import '../widgets/login_style.dart';
import '../widgets/signin_botton.dart';
import 'package:flutter/material.dart';

class ResetEmailSentScreen extends StatefulWidget {
  final String email;

  const ResetEmailSentScreen({super.key, required this.email});

  @override
  State<ResetEmailSentScreen> createState() => _ResetEmailSentScreenState();
}

class _ResetEmailSentScreenState extends State<ResetEmailSentScreen> {
  void resendEmail() async {
    bool success =
        await ResetPasswordService.sendPasswordResetEmail(widget.email);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Email sent successfully! Please check your inbox.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to resend email. Please try again later.")),
      );
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
                "Email has been sent!",
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
                "Please check your inbox and click on the received link to reset your password.",
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
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(0, 224, 224, 224),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/emailsent.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Login Button
            SigninButton(
              buttonText: 'Sign Up',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }, // Navigate to the SignUpScreen
            ),

            const SizedBox(height: 20),
            // Resend email option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn’t receive the link? "),
                GestureDetector(
                  onTap: resendEmail,
                  child: const Text(
                    "Resend",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
