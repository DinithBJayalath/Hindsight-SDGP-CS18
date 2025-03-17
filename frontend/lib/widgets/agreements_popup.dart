import 'package:flutter/material.dart';

/// A widget that displays the Terms & Conditions popup.
/// It shows the terms text along with Accept and Decline buttons.
class AgreementsPopup extends StatelessWidget {
  /// Callback when the user accepts the terms.
  final VoidCallback onAccept;

  /// Callback when the user declines the terms.
  final VoidCallback onDecline;

  const AgreementsPopup({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Terms & Conditions"),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please review the following terms and conditions carefully before proceeding.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "1. You must be at least 18 years old to use this application.\n\n"
              "2. All data provided will be used solely for app functionality and will not be shared with third parties.\n\n"
              "3. The application is provided 'as is' without any warranties of any kind.\n\n"
              "4. You agree to use the app responsibly and not to misuse any features.\n\n"
              "5. Your use of this app constitutes acceptance of these terms.",
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onDecline,
          child: const Text("Decline"),
        ),
        ElevatedButton(
          onPressed: onAccept,
          child: const Text("Accept"),
        ),
      ],
    );
  }
}
