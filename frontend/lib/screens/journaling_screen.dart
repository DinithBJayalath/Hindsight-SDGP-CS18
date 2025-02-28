import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    }
  ];

  // Method to get the current date
  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(now);
  }

  // Add a new journal entry
  void addJournalEntry(String title, String emoji, String content) {
    setState(() {
      journalEntries.insert(0, {
        'title': title,
        'emoji': emoji,
        'date': getCurrentDate(),
        'entryContent': content,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Journal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JournalContainer(userName: userName),
            const SizedBox(height: 16),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalWritingScreen(
                addJournalEntry: addJournalEntry,
              ),
            ),
          );
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}
