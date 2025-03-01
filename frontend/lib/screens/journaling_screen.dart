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

  // Delete journal entry function
  void deleteJournalEntry(int index) {
    setState(() {
      journalEntries.removeAt(index);
    });
  }

  // Show confirmation dialog before deleting
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Are you sure you want to delete this entry?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteJournalEntry(index); // Delete the entry
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Entry deleted')),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      _showDeleteConfirmationDialog(index);
                      return false;
                    },
                    child: JournalEntryWidget(
                      title: entry['title']!,
                      date: entry['date']!,
                      emoji: entry['emoji']!,
                    ),
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
                isEditMode: false,
                entryIndex: -1,
                deleteJournalEntry: deleteJournalEntry,
              ),
            ),
          );
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}
