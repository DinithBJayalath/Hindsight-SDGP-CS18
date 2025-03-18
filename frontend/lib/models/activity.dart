import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String routeName;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.routeName,
  });
}

// This will be replaced with API data in the future
final List<Activity> activities = [
  Activity(
    id: 'breathing',
    title: 'Deep Breathing',
    description:
        'A guided breathing activity that helps you reduce stress, improve focus, and calm your mind.',
    icon: Icons.self_improvement,
    routeName: '/breathing',
  ),
  Activity(
    id: 'art',
    title: 'Expressive Art',
    description: 'A digital canvas for you to draw or doodle your emotions.',
    icon: Icons.palette,
    routeName: '/art',
  ),
  Activity(
    id: 'letter',
    title: 'Letter to Future Self',
    description:
        'Write a letter to yourself, set a future date, and receive the letter as a reminder.',
    icon: Icons.mail,
    routeName: '/letters',
  ),
];
