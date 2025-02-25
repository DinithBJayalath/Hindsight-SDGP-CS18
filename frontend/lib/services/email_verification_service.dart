// lib/services/email_verification_service.dart
import 'dart:math';

class EmailVerificationService {
  /// Generates a 6-digit verification code and simulates sending an email.
  static Future<String> sendVerificationEmail(String email) async {
    // Generate a random 6-digit code.
    String verificationCode = (100000 + Random().nextInt(900000)).toString();

    // In a real app, you would send this code to the email using an email API.
    print("Sending verification email to $email with code: $verificationCode");

    // Simulate network delay.
    await Future.delayed(const Duration(seconds: 1));

    // Return the generated code so it can be checked.
    return verificationCode;
  }
}
