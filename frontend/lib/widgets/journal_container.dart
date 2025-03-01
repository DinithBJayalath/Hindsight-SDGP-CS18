import 'package:flutter/material.dart';

class JournalContainer extends StatelessWidget {
  final String userName;

  const JournalContainer({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        "$userName's Journal",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
