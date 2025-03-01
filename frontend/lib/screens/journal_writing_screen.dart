import 'package:flutter/material.dart';

class JournalWritingScreen extends StatefulWidget {
  final Function(String, String, String) addJournalEntry;
  final Function(int) deleteJournalEntry;
  final bool isEditMode;
  final int entryIndex;

  const JournalWritingScreen({
    super.key,
    required this.addJournalEntry,
    required this.isEditMode,
    required this.entryIndex,
    required this.deleteJournalEntry,
  });

  @override
  _JournalWritingScreenState createState() => _JournalWritingScreenState();
}

class _JournalWritingScreenState extends State<JournalWritingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();

  void _saveEntry() {
    if (_titleController.text.isNotEmpty && _entryController.text.isNotEmpty) {
      widget.addJournalEntry(
        _titleController.text,
        '😊', // Default emoji for now
        _entryController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? "Edit Entry" : "New Entry"),
        actions: [
          if (widget.isEditMode)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                widget.deleteJournalEntry(widget.entryIndex);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20.0), // Increased padding for better layout
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _entryController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Write your thoughts...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.isEditMode ? "Update" : "Save",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
