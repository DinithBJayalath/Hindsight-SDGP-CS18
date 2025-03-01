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

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;
  double fontSize = 16.0;
  Color textColor = Colors.black;

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

  void _toggleBold() {
    setState(() {
      isBold = !isBold;
    });
  }

  void _toggleItalic() {
    setState(() {
      isItalic = !isItalic;
    });
  }

  void _toggleUnderline() {
    setState(() {
      isUnderlined = !isUnderlined;
    });
  }

  void _changeFontSize(double size) {
    setState(() {
      fontSize = size;
    });
  }

  void _changeTextColor(Color color) {
    setState(() {
      textColor = color;
    });
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
        padding: const EdgeInsets.all(20.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold,
                      color: isBold ? Colors.blue : Colors.black),
                  onPressed: _toggleBold,
                ),
                IconButton(
                  icon: Icon(Icons.format_italic,
                      color: isItalic ? Colors.blue : Colors.black),
                  onPressed: _toggleItalic,
                ),
                IconButton(
                  icon: Icon(Icons.format_underline,
                      color: isUnderlined ? Colors.blue : Colors.black),
                  onPressed: _toggleUnderline,
                ),
                IconButton(
                  icon: Icon(Icons.color_lens, color: textColor),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Select Text Color"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ColorPickerButton(
                              color: Colors.black,
                              onPressed: () => _changeTextColor(Colors.black),
                            ),
                            ColorPickerButton(
                              color: Colors.blue,
                              onPressed: () => _changeTextColor(Colors.blue),
                            ),
                            ColorPickerButton(
                              color: Colors.red,
                              onPressed: () => _changeTextColor(Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                DropdownButton<double>(
                  value: fontSize,
                  items: [14.0, 16.0, 18.0, 20.0, 24.0].map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size.toInt().toString(),
                          style: TextStyle(fontSize: size)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) _changeFontSize(value);
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _entryController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: isUnderlined
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  color: textColor,
                ),
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

class ColorPickerButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const ColorPickerButton(
      {super.key, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.circle, color: color, size: 30),
      onPressed: () {
        onPressed();
        Navigator.pop(context);
      },
    );
  }
}
