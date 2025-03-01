import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalWritingScreen extends StatefulWidget {
  final Function(String, String, String) addJournalEntry;
  final Function(int) deleteJournalEntry;
  final bool isEditMode;
  final int entryIndex;
  final String? existingDate;

  const JournalWritingScreen({
    super.key,
    required this.addJournalEntry,
    required this.isEditMode,
    required this.entryIndex,
    required this.deleteJournalEntry,
    this.existingDate,
  });

  @override
  _JournalWritingScreenState createState() => _JournalWritingScreenState();
}

class _JournalWritingScreenState extends State<JournalWritingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();
  double fontSize = 16.0;
  String? errorMessage;
  late String displayedDate;

  @override
  void initState() {
    super.initState();
    displayedDate = widget.isEditMode
        ? widget.existingDate!
        : DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  void _showSaveConfirmationDialog() {
    if (_titleController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Title cannot be empty!";
      });
      return;
    } else if (_titleController.text.length > 50) {
      setState(() {
        errorMessage = "Title cannot exceed 50 characters!";
      });
      return;
    } else if (_entryController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Journal content cannot be empty!";
      });
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.isEditMode ? "Update Entry?" : "Save New Entry?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            widget.isEditMode
                ? "Are you sure you want to update this journal entry?"
                : "Do you want to save this new journal entry?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _saveEntry();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(
                widget.isEditMode ? "Update" : "Save",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Entry?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Text(
            "Are you sure you want to delete this entry? This action cannot be undone.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.deleteJournalEntry(widget.entryIndex);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                "Delete",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveEntry() {
    widget.addJournalEntry(
      _titleController.text,
      '😊',
      _entryController.text,
    );
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
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _showDeleteConfirmationDialog,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            Text(
              "Date: $displayedDate",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 10),

            // Font Size Adjuster
            Column(
              children: [
                Text("Font Size: ${fontSize.toInt()}"),
                Slider(
                  value: fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 6,
                  label: fontSize.toStringAsFixed(0),
                  onChanged: (value) {
                    setState(() {
                      fontSize = value;
                    });
                  },
                ),
              ],
            ),

            Expanded(
              child: TextField(
                controller: _entryController,
                maxLines: null,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  hintText: "Write your thoughts...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showSaveConfirmationDialog,
              child: Text(widget.isEditMode ? "Update" : "Save"),
            ),
          ],
        ),
      ),
    );
  }
}
