import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'described_mood.dart'; // Import the described_mood.dart file to access the MoodDescribeScreen
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoodTrackerScreen(),
    );
  }
}

class MoodTrackerScreen extends StatefulWidget {
  @override
  MoodTrackerScreenState createState() => MoodTrackerScreenState();
}

class MoodTrackerScreenState extends State<MoodTrackerScreen> {
  double moodValue = 2; // Default mood index
  String userName = "User"; // Default username
  final _storage = const FlutterSecureStorage();

  final List<String> moods = [
    "😢 Very Sad",
    "😟 Sad",
    "😐 Neutral",
    "😊 Happy",
    "😄 Very Happy"
  ];
  final List<Color> moodColors = [
    Colors.red,
    Colors.orange,
    Colors.grey,
    Colors.lightGreen,
    Colors.greenAccent
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final storedName = await _storage.read(key: 'user_name');
      if (storedName != null && storedName.isNotEmpty) {
        setState(() {
          userName = storedName;
        });
      }
    } catch (e) {
      print('Error loading username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    int moodIndex = moodValue.round();

    return Scaffold(
        body: Container(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              moodColors[moodIndex]
                  .withOpacity(0.3), // Change the bottom color dynamically
              Colors.white, // Keep the top color white
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 40),
                Text(
                  "Hey, $userName!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                Text(
                  "How are you feeling today?",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: 50),

                // Animated Mood Emoji
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: moodColors[moodIndex].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      moods[moodIndex].split(" ")[0], // Emoji only
                      style: TextStyle(fontSize: 100),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "I'm Feeling",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  moods[moodIndex].split(" ").sublist(1).join(" "), // Text only
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),

                SizedBox(height: 20),

                // Mood Slider
                Slider(
                  value: moodValue,
                  min: 0,
                  max: 4,
                  divisions: 4,
                  activeColor: moodColors[moodIndex],
                  thumbColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      moodValue = value;
                    });
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("😢 Very Sad",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text("😄 Very Happy",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),

                SizedBox(height: 50),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 68, 183, 255),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  ),
                  onPressed: () {
                    // Navigate to the MoodDescribeScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodDescribeScreen(
                            mood: moods[moodIndex],
                            moodColor: moodColors[moodIndex]),
                      ),
                    );
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
