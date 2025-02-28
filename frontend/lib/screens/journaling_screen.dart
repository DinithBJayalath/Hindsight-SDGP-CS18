import 'package:flutter/material.dart';
import '../widgets/journal_container.dart';
import '../widgets/journal_entry_widget.dart';
import 'journal_writing_screen.dart';

class JournalingScreen extends StatefulWidget {
  const JournalingScreen({super.key});

  @override
  _JournalingScreenState createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  final String userName = "John"; // Replace with dynamic username
  List<Map<String, String>> journalEntries = [
    {
      'title': 'My first journal entry',
      'emoji': '😊',
      'date': '15 Feb 2025',
      'entryContent': 'Today was a great day!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Journal Entries")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JournalContainer(userName: userName),
          Expanded(
            child: ListView.builder(
              itemCount: journalEntries.length,
              itemBuilder: (context, index) {
                var entry = journalEntries[index];
                return JournalEntryWidget(
                  title: entry['title']!,
                  date: entry['date']!,
                  emoji: entry['emoji']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
