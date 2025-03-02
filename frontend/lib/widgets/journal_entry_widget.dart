import 'package:flutter/material.dart';

class JournalEntryWidget extends StatelessWidget {
  final String title;
  final String date; // The date passed to this widget
  final String emoji;

  const JournalEntryWidget({
    super.key,
    required this.title,
    required this.date,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
      margin: EdgeInsets.only(bottom: screenWidth * 0.02), // Responsive margin
      decoration: BoxDecoration(
        color: Color(0xFFBFE6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      screenWidth * 0.04, // Responsive font size for title
                ),
              ),
              SizedBox(
                  height: screenWidth *
                      0.01), // Responsive space between title and date
              Text(
                date, // This will show the date the entry was created.
                style: TextStyle(
                  fontSize: screenWidth * 0.03, // Responsive font size for date
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          Text(
            emoji,
            style: TextStyle(
              fontSize: screenWidth * 0.06, // Responsive font size for emoji
            ),
          ),
        ],
      ),
    );
  }
}
