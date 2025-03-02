import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 58),
            Text(
              'Activities',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),
            ActivityCard(
              title: 'Deep Breathing',
              description:
                  'A guided breathing activity that helps you reduce stress, improve focus, and calm your mind.',
            ),
            ActivityCard(
              title: 'Expressive Art',
              description:
                  'A digital canvas for you to draw or doodle your emotions.',
            ),
            ActivityCard(
              title: 'Letter to Future Self',
              description:
                  'Write a letter to yourself, set a future date, and receive the letter as a reminder.',
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;

  const ActivityCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(191, 230, 255, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
