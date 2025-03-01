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
  List<Map<String, String>> journalEntries = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("My Journal", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20.0), // Increased padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JournalContainer(userName: userName),
            SizedBox(height: 16),
            Expanded(
              child: journalEntries.isEmpty
                  ? Center(
                      child: Text(
                        "No journal entries yet. Tap the '+' button to start writing!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: journalEntries.length,
                      itemBuilder: (context, index) {
                        var entry = journalEntries[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0), // Added space between entries
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
        backgroundColor: Colors.blueAccent, // Better button visibility
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
        child: Icon(Icons.create, size: 28),
      ),
    );
  }
}
