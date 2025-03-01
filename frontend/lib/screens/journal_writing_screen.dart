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

  void _deleteEntry() {
    widget.deleteJournalEntry(widget.entryIndex);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? "Edit Entry" : "New Entry"),
        actions: [
          if (widget.isEditMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteEntry,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            TextField(
              controller: _entryController,
              decoration:
                  const InputDecoration(hintText: "Write your thoughts..."),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text(widget.isEditMode ? "Update" : "Save"),
            ),
          ],
        ),
      ),
    );
  }
}
