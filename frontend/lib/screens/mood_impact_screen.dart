import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/API_Service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoodImpactScreen extends StatefulWidget {
  final String mood;
  final Color moodColor;
  final String? emotion;
  const MoodImpactScreen(
      {Key? key,
      required this.mood,
      required this.emotion,
      required this.moodColor})
      : super(key: key);
  @override
  MoodImpactScreenState createState() =>
      MoodImpactScreenState(mood: mood, emotion: emotion, moodColor: moodColor);
}

class MoodImpactScreenState extends State<MoodImpactScreen> {
  final String mood;
  final Color moodColor;
  late String emoji;
  late String text;
  final String? emotion;
  // Using the API_URL from environment variables
  final ApiService _apiService =
      ApiService(baseUrl: dotenv.env['API_URL'] ?? '');
  bool _isLoading = false;
  String _responseMessage = '';
  MoodImpactScreenState(
      {required this.mood, required this.emotion, required this.moodColor}) {
    final parts = mood.split(' ');
    emoji = parts[0];
    text = parts.sublist(1).join(' ');
  }
  List<String> impactFactors = [
    "Health",
    "Fitness",
    "Self-Care",
    "Family",
    "Friends",
    "Work",
    "Education",
    "Money",
    "Love",
    "Vacation",
    "Weather",
    "Traffic"
  ];

  List<String> selectedFactors = [];

  Future<void> _sendRequest() async {
    // Format data exactly as expected by backend MoodCheckDto
    final Map<String, dynamic> moodData = {
      "mood": mood,
      "emotion": emotion ?? "",
      "factors": selectedFactors
    };

    print("Sending mood data to backend: $moodData");

    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    try {
      // Get token to verify it exists
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      print("Access token available: ${token != null}");

      // Use direct HTTP call to see exactly what's happening
      final url = '${dotenv.env['API_URL'] ?? ''}/moodcheck';
      print("Sending direct HTTP POST to: $url");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode(moodData);

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _responseMessage = 'Mood saved successfully!';
        });
        print("Mood entry successfully added to user's mood collection");
      } else if (response.statusCode == 400 &&
          response.body.contains("Profile ID is required")) {
        // Special handling for profile ID error - retry after a short delay
        print("Profile ID error detected, waiting briefly and retrying...");
        await Future.delayed(Duration(seconds: 2)); // Wait 2 seconds

        // Check the auth state again
        final refreshedToken = await storage.read(key: 'access_token');
        if (refreshedToken != null) {
          print("Retrying request with refreshed state...");

          // Make a second attempt
          final retryResponse = await http.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $refreshedToken',
            },
            body: body,
          );

          print("Retry response status: ${retryResponse.statusCode}");
          print("Retry response body: ${retryResponse.body}");

          if (retryResponse.statusCode >= 200 &&
              retryResponse.statusCode < 300) {
            setState(() {
              _responseMessage = 'Mood saved successfully on retry!';
            });
            print(
                "Mood entry successfully added to user's mood collection on retry");
          } else {
            setState(() {
              _responseMessage =
                  'Error on retry: ${retryResponse.statusCode} ${retryResponse.body}';
            });
          }
        }
      } else {
        setState(() {
          _responseMessage = 'Error: ${response.statusCode} ${response.body}';
        });
      }
    } catch (e) {
      print("Error sending mood data: $e");
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
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
              children: [
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
                SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  emotion!,
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
                      ...impactFactors
                          .map((factor) => _buildSelectableButton(factor))
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Done Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedFactors != null
                      ? Color.fromARGB(255, 68, 183, 255)
                      : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                ),
                onPressed: () async {
                  await _sendRequest(); // Call the API request instead of showing a popup
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
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
          border: Border.all(
              color: isSelected ? Colors.blue.shade900 : Colors.transparent,
              width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
