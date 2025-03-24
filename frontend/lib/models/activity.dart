import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String routeName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.routeName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      icon: _getIconData(json['icon']),
      routeName: json['routeName'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'self_improvement':
        return Icons.self_improvement;
      case 'palette':
        return Icons.palette;
      case 'mail':
        return Icons.mail;
      default:
        return Icons.help_outline;
    }
  }
}

// This will be replaced with API data
final List<Activity> activities = [
  Activity(
    id: 'breathing',
    title: 'Deep Breathing',
    description:
        'A guided breathing activity that helps you reduce stress, improve focus, and calm your mind.',
    icon: Icons.self_improvement,
    routeName: '/breathing',
    isActive: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Activity(
    id: 'art',
    title: 'Expressive Art',
    description: 'A digital canvas for you to draw or doodle your emotions.',
    icon: Icons.palette,
    routeName: '/art',
    isActive: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Activity(
    id: 'letter',
    title: 'Letter to Future Self',
    description:
        'Write a letter to yourself, set a future date, and receive the letter as a reminder.',
    icon: Icons.mail,
    routeName: '/letters',
    isActive: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
