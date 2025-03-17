import 'package:flutter/material.dart';

class PopupMessage {
  static void show(BuildContext context, String message,
      {bool isSuccess = true}) {
    if (!context.mounted) return; // Ensure the context is still valid

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            isSuccess ? 'Success' : 'Error',
            style: TextStyle(
              color: isSuccess ? Colors.green : Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 4,
        );
      },
    );
  }
}
