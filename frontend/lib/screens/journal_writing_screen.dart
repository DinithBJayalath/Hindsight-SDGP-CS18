import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../services/API_Service.dart';

class JournalWritingScreen extends StatefulWidget {
  final Function(int, String, String, String, String) addJournalEntry;
  final String title;
  final String emoji;
  final String date;
  final String entryContent;
  final bool isEditMode;
  final int entryIndex;
  final Function(int) deleteJournalEntry;

  const JournalWritingScreen({
    super.key,
    required this.addJournalEntry,
    this.title = '',
    this.emoji = '😊',
    this.date = '',
    this.entryContent = '',
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
  // The following 3 are variables to handel the backend requests and responses
  final ApiService _apiService = ApiService(baseUrl: 'http://192.168.8.195:3000');
  bool _isLoading = false;
  String _responseMessage = '';
  String selectedEmoji = '😊'; // Default emoji
  bool isBold = false; // Flag for bold text
  bool isItalic = false; // Flag for italic text
  bool isUnderlined = false; // Flag for underlined text
  Color textColor = Colors.black; // Default text color
  double fontSize = 16.0; // Initial font size
  TextAlign textAlign = TextAlign.left; // Default text alignment
  TextStyle currentTextStyle = TextStyle(fontSize: 16.0, color: Colors.black);

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(now);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _titleController.text = widget.title;
      _entryController.text = widget.entryContent;
      selectedEmoji = widget.emoji;
    }
  }

  // Update text style based on text selection
  void updateTextStyle() {
    final textSelection = _entryController.selection;
    if (textSelection.isValid) {
      setState(() {
        currentTextStyle = TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          decoration:
              isUnderlined ? TextDecoration.underline : TextDecoration.none,
          color: textColor,
          fontSize: fontSize,
        );
      });
    }
  }

  void _changeTextColor() {
    setState(() {
      textColor = textColor == Colors.black ? Colors.blue : Colors.black;
      updateTextStyle();
    });
  }

  void _selectEmoji(String emoji) {
    setState(() {
      selectedEmoji = emoji;
    });
  }

  void _limitTitleWords() {
    String title = _titleController.text;
    List<String> words = title.split(" ");
    if (words.length > 10) {
      words = words.sublist(0, 10); // Take only the first 10 words
      _titleController.text = words.join(" ");
      _titleController.selection = TextSelection.fromPosition(
          TextPosition(offset: _titleController.text.length));
    }
  }

  // Validation to check if the title and entry content are not empty
  bool _validateInputs() {
    if (_titleController.text.isEmpty || _entryController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void _showConfirmationDialog() {
    if (!_validateInputs()) {
      // If validation fails, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide both title and content for the entry.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit the method if validation fails
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.isEditMode
                ? "Are you sure you want to update your entry?" // If editing
                : "Are you sure you want to save your entry?", // If creating new entry
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Cancel the update
                Navigator.pop(context);
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
              onPressed: () async {
                if (!_isLoading) {
                  await _sendRequest(); // Correctly calling the function
                  print('status code: $_responseMessage');
                  // Proceed with saving or updating the journal entry
                  widget.addJournalEntry(
                    widget.entryIndex, // Use the index for update or -1 for new
                    _titleController.text,
                    selectedEmoji,
                    widget.isEditMode ? widget.date : getCurrentDate(), // Update date only for edit mode
                    _entryController.text,
                  );

                  Navigator.pop(context); // Close the confirmation dialog
                  Navigator.pop(context); // Go back to JournalScreen

                  // Show the confirmation message in the JournalScreen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Color(0xFFBFE6FF),
                      content: Text(
                        widget.isEditMode
                            ? 'Your entry has been updated!'
                            : 'Your entry has been saved!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                widget.isEditMode ? "Update" : "Save",
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

  void _showDeleteConfirmationDialog() {
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
                Navigator.pop(context); // Close the delete confirmation dialog
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
                widget.deleteJournalEntry(
                    widget.entryIndex); // Delete the journal entry
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Return to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color.fromARGB(255, 97, 210, 255),
                    content: Text(
                      'Entry Deleted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              child: Text(
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

  // This method handles sending requests to the backend
  Future<void> _sendRequest() async {
    // query from the user's journal entry
    final query = _entryController.text.trim();
    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    try {
      // Send the request to the backend
      final response = await _apiService.getData('algorithms/analyze', queryParams: {'query': query});

      setState(() {
        _responseMessage = 'Response: ${response['result']}';
      });
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Reduced height
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 40, // Reduce the width of the leading icon
            leading: IconButton(
              padding: EdgeInsets.zero, // Remove padding from back button
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Padding(
              padding:
                  const EdgeInsets.only(top: 4.0), // Move title up slightly
              child: Text(
                getCurrentDate(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            centerTitle: true,
            actions: [
              if (widget.isEditMode)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: _showDeleteConfirmationDialog,
                ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBFE6FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    widget.isEditMode ? 'Update' : 'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 8.0, 16.0, 16.0), // Reduced top padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title section with adjusted padding
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 12.0), // Reduced bottom padding
              child: TextField(
                controller: _titleController,
                onChanged: (text) => _limitTitleWords(),
                decoration: InputDecoration(
                  hintText: "Enter Your Journal Title",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 4.0), // Reduced vertical padding
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                  ),
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Formatting toolbar with improved spacing
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFBFE6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.format_bold),
                    onPressed: () {
                      setState(() {
                        isBold = !isBold;
                        updateTextStyle();
                      });
                    },
                    color: isBold ? Colors.blue : Colors.black,
                    padding: EdgeInsets.all(12),
                  ),
                  IconButton(
                    icon: Icon(Icons.format_italic),
                    onPressed: () {
                      setState(() {
                        isItalic = !isItalic;
                        updateTextStyle();
                      });
                    },
                    color: isItalic ? Colors.blue : Colors.black,
                    padding: EdgeInsets.all(12),
                  ),
                  IconButton(
                    icon: Icon(Icons.format_underline),
                    onPressed: () {
                      setState(() {
                        isUnderlined = !isUnderlined;
                        updateTextStyle();
                      });
                    },
                    color: isUnderlined ? Colors.blue : Colors.black,
                    padding: EdgeInsets.all(12),
                  ),
                  IconButton(
                    icon: Icon(Icons.color_lens),
                    onPressed: _changeTextColor,
                    color:
                        textColor == Colors.blue ? Colors.blue : Colors.black,
                    padding: EdgeInsets.all(12),
                  ),
                  IconButton(
                    icon: Icon(Icons.text_fields),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Enter Font Size:',
                                      style: TextStyle(fontSize: 18)),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: fontSize.toString(),
                                    ),
                                    onSubmitted: (value) {
                                      setState(() {
                                        fontSize =
                                            double.tryParse(value) ?? fontSize;
                                        updateTextStyle();
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 97, 210, 255)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    padding: EdgeInsets.all(12),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Journal content area with improved styling
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFBFE6FF).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _entryController,
                  maxLines: null,
                  style: currentTextStyle,
                  decoration: InputDecoration(
                    hintText: "Write about your day here...",
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
