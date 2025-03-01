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
    return ListTile(
      leading: Text(emoji, style: TextStyle(fontSize: 24)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(date),
    );
  }
}
