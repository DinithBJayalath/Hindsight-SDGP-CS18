import 'package:flutter/material.dart';

class JournalContainer extends StatelessWidget {
  final String userName;

  const JournalContainer({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            0, 255, 255, 255), // Background color is white now
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0, // Responsive horizontal padding
        vertical: screenWidth * 0.01, // Responsive vertical padding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$userName's Journal", // Dynamic user name with 'Journal'
            style: TextStyle(
              fontSize:
                  screenWidth * 0.06, // Dynamic font size based on screen width
              fontWeight: FontWeight.bold,
              color: Colors.black, // Black color for the name
            ),
          ),
          SizedBox(height: 4), // Added spacing for better alignment
        ],
      ),
    );
  }
}
