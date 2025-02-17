import 'package:flutter/material.dart';

class PopupMessage {
  static void show(BuildContext context, String message,
      {bool isSuccess = true}) {
    if (!context.mounted) return; // Ensure the context is still valid

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            isSuccess ? 'Success' : 'Error',
            style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close popup safely
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
