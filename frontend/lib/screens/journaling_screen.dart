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
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialEntries();
  }

  void _loadInitialEntries() {
    journalEntries = [
      {
        'title': 'My first journal entry',
        'emoji': '😊',
        'date': '15 Feb 2025',
        'entryContent': 'Today was a great day!',
      },
      {
        'title': 'A busy day at work',
        'emoji': '😓',
        'date': '14 Feb 2025',
        'entryContent': 'Had a lot of meetings, but learned a lot!',
      }
    ];
    setState(() {});
  }

  String getCurrentDate() {
    return DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  void _updateState(Function modifyList) {
    setState(() {
      modifyList();
    });
  }

  void addJournalEntry(String title, String emoji, String content) {
    _updateState(() {
      journalEntries.insert(0, {
        'title': title,
        'emoji': emoji,
        'date': getCurrentDate(),
        'entryContent': content,
      });
    });
  }

  void deleteJournalEntry(int index) {
    _updateState(() {
      journalEntries.removeAt(index);
    });
  }

  List<Map<String, String>> getFilteredEntries() {
    return journalEntries
        .where((entry) =>
            entry['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JournalContainer(userName: userName),
            SizedBox(height: 16),
            TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: "Search Entries...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: getFilteredEntries().isEmpty
                  ? Center(
                      child: Text(
                        "No matching entries found.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: getFilteredEntries().length,
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        var entry = getFilteredEntries()[index];
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
        backgroundColor: Colors.blueAccent,
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
