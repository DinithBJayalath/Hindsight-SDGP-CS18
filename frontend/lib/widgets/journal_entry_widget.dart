import 'package:flutter/material.dart';

class JournalEntryWidget extends StatelessWidget {
  final String title;
  final String date;
  final String emoji;

  const JournalEntryWidget({
    super.key,
    required this.title,
    required this.date,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded edges
      ),
      elevation: 3, // Slight shadow effect
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Text(
              emoji,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
