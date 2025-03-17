import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'described_mood.dart'; // Import the described_mood.dart file to access the MoodDescribeScreen

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
  String userName = "Ramudi"; // Example user name

  final List<String> moods = ["😢 Very Sad", "😟 Sad", "😐 Neutral", "😊 Happy", "😄 Very Happy"];
  final List<Color> moodColors = [Colors.red, Colors.orange, Colors.grey, Colors.lightGreen, Colors.greenAccent];

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
                moodColors[moodIndex].withOpacity(0.3),  // Change the bottom color dynamically
                Colors.white,                            // Keep the top color white
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black ),
                  ),
                  SizedBox(height: 60),
                  Text(
                    "Hey, $userName!",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "How are you feeling today?",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(height: 60),

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
                        style: TextStyle(fontSize: 120),
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
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
                      Text("😢 Very Sad", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      Text("😄 Very Happy", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  SizedBox(height: 50),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to the MoodDescribeScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoodDescribeScreen(mood: moods[moodIndex]),
                        ),
                      );
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
      )
    );
  }
}
