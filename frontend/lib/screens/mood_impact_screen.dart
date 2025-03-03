import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MoodImpactApp());
}

class MoodImpactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoodImpactScreen(),
    );
  }
}

class MoodImpactScreen extends StatefulWidget {
  @override
  MoodImpactScreenState createState() => MoodImpactScreenState();
}

class MoodImpactScreenState extends State<MoodImpactScreen> {
  List<String> impactFactors = [
    "Health", "Fitness", "Self-Care",
    "Family", "Friends", "Work",
    "Education", "Money"
  ];

  List<String> placeholderTexts = ["Text", "Text", "Text", "Text", "Text", "Text"];
  List<String> selectedFactors = [];

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black54, // Dark background like the screenshot
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Mood Emoji & Text
              Column(
                children: [
                  Text(
                    "😊",
                    style: TextStyle(fontSize: 60),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Happy",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Emotion, Emotion, Emotion",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 15),

              // Question Text
              Text(
                "What's having the biggest impact on you?",
                style: TextStyle(fontSize: 16),
              ),
              Divider(thickness: 1),

              SizedBox(height: 10),

              // Impact Factor Buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...impactFactors.map((factor) => _buildSelectableButton(factor)),
                  ...placeholderTexts.map((text) => _buildSelectableButton(text)),
                ],
              ),

              SizedBox(height: 20),

              // Done Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Perform action when done is clicked
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected: ${selectedFactors.join(", ")}")),
                  );
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableButton(String label) {
    bool isSelected = selectedFactors.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedFactors.remove(label);
          } else {
            selectedFactors.add(label);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.lightBlue.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.blue.shade900 : Colors.transparent, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
