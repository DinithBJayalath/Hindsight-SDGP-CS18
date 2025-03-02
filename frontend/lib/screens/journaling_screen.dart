import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
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
    {
      'title': 'Feeling happy',
      'emoji': '😊',
      'date': '14 Feb 2025',
      'entryContent': 'Had a lovely dinner with friends.',
    },
    {
      'title': 'Tough day',
      'emoji': '😞',
      'date': '12 Feb 2025',
      'entryContent': 'A rough day at work, but I learned a lot.',
    }
  ];

  String searchQuery = '';

  // Method to get current date
  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(now);
  }

  // Method to filter entries based on the search query
  List<Map<String, String>> getFilteredEntries() {
    return journalEntries
        .where((entry) =>
            entry['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // Add journal entry function
  void addJournalEntry(
      int index, String title, String emoji, String date, String entryContent) {
    if (index == -1) {
      // Add new entry at the top (index 0)
      setState(() {
        journalEntries.insert(0, {
          // insert at the beginning
          'title': title,
          'emoji': emoji,
          'date': getCurrentDate(),
          'entryContent': entryContent,
        });
      });
    } else {
      // Update existing entry
      setState(() {
        journalEntries[index] = {
          'title': title,
          'emoji': emoji,
          'date': date,
          'entryContent': entryContent,
        };
      });
    }
  }

  // Delete journal entry function
  void deleteJournalEntry(int index) {
    setState(() {
      journalEntries.removeAt(index); // Removes entry at the specified index
    });
  }

  // Show confirmation dialog before deleting
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Are you sure you want to delete this entry?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromARGB(255, 97, 210, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteJournalEntry(index); // Delete the entry
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Entry deleted')),
                );
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Color.fromARGB(255, 97, 210, 255),
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JournalContainer(userName: userName),
            SizedBox(height: 10),
            // Search bar implementation
            TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: "Search Entries",
                filled: true,
                fillColor: Color(0xFFBFE6FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Hi ! Tell me about your day... I'm waiting to hear your story...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFBFE6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.create),
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
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: const Color.fromARGB(255, 0, 0, 0),
              thickness: 2,
            ),
            SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: getFilteredEntries().length,
                itemBuilder: (context, index) {
                  var entry = getFilteredEntries()[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JournalWritingScreen(
                            addJournalEntry: addJournalEntry,
                            title: entry['title']!,
                            emoji: entry['emoji']!,
                            date: entry['date']!,
                            entryContent: entry['entryContent']!,
                            isEditMode: true,
                            entryIndex: index,
                            deleteJournalEntry: deleteJournalEntry,
                          ),
                        ),
                      );
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
    );
  }
}
