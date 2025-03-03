import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Full-screen mode
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
      backgroundColor: Colors.white, // Full-screen background
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Mood Emoji & Text
            Column(
              children: const [
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
                  "Emotion",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Question Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    "What's having the biggest impact on you?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Divider(thickness: 1),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Impact Factor Buttons (Scrollable)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ...impactFactors.map((factor) => _buildSelectableButton(factor)),
                      ...placeholderTexts.map((text) => _buildSelectableButton(text)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Done Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected: ${selectedFactors.join(", ")}")),
                  );
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
