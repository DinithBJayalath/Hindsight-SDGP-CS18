import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mood_impact_screen.dart';



class MoodDescribeScreen extends StatefulWidget {
  final String mood;
  final Color moodColor;
  const MoodDescribeScreen({Key? key, required this.mood, required this.moodColor}): super(key: key);
  @override
  MoodDescribeScreenState createState() => MoodDescribeScreenState(mood: this.mood, moodColor: this.moodColor);
}

class MoodDescribeScreenState extends State<MoodDescribeScreen> {
  final String mood;
  final Color moodColor;
  late String emoji;
  late String text;
  MoodDescribeScreenState({required this.mood, required this.moodColor}) {
    final parts = mood.split(' ');
    emoji = parts[0];
    text = parts.sublist(1).join(' ');
  }
  String selectedMood = "Happy"; // Default mood
  String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  Map<String,List<String>> emotions = {
    "very sad": ["Sadness", "Anger", "Worry", "Hate"],
    "sad": ["Sadness", "Anger", "Worry", "Hate"],
    "neutral": ["relief", "Surprise", "Neutral", "Boredom"],
    "happy": ["Happiness", "Fun", "Love", "Enthusiasm"],
    "very happy": ["Happiness", "Fun", "Love", "Enthusiasm"]
  };
  String? selectedEmotion; // Track selected emotion

  @override
  Widget build(BuildContext context) {
    print(text);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Row (Back Button, Date, Close Button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Animated Mood Emoji
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: moodColor.withAlpha(120),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Mood Title
              Text(
                text,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // "What describes this feeling?" Text
              const Text(
                "What described this feeling?",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 1),

              const SizedBox(height: 20),

              // Emotion Selection Buttons (Grid)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                  children: (emotions[text.toLowerCase()] ?? []).map((emotion) {
                    bool isSelected = selectedEmotion == emotion;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedEmotion = emotion; // Select emotion
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.lightBlue.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSelected ? Colors.blue.shade900 : Colors.transparent, width: 2),
                        ),
                        child: Text(
                          emotion,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ),
              const SizedBox(height: 40),

              // "Next" Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedEmotion != null? Color.fromARGB(255, 68, 183, 255): Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                ),
                onPressed: () {
                  if (selectedEmotion != null) {
                    // Navigate to the MoodDescribeScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodImpactScreen(mood: mood, emotion: selectedEmotion, moodColor: moodColor),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
