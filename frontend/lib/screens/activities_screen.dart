import 'package:flutter/material.dart';
import 'dart:ui';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  int _selectedIndex = 4; // Activities tab is selected by default

  void _handleActivityTap(String activity) {
    // TODO: Navigate to respective activity screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $activity...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Activities',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Choose an activity to help improve your mental wellbeing',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                ActivityCard(
                  title: 'Deep Breathing',
                  description:
                      'A guided breathing activity that helps you reduce stress, improve focus, and calm your mind.',
                  icon: Icons.self_improvement,
                  onTap: () => _handleActivityTap('Deep Breathing'),
                ),
                const SizedBox(height: 16),
                ActivityCard(
                  title: 'Expressive Art',
                  description:
                      'A digital canvas for you to draw or doodle your emotions.',
                  icon: Icons.palette,
                  onTap: () => _handleActivityTap('Expressive Art'),
                ),
                const SizedBox(height: 16),
                ActivityCard(
                  title: 'Letter to Future Self',
                  description:
                      'Write a letter to yourself, set a future date, and receive the letter as a reminder.',
                  icon: Icons.mail,
                  onTap: () => _handleActivityTap('Letter to Future Self'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black.withOpacity(0.03),
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.black54),
            selectedIcon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined, color: Colors.black54),
            selectedIcon: Icon(Icons.book, color: Colors.black),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.mood_outlined, color: Colors.black54),
            selectedIcon: Icon(Icons.mood, color: Colors.black),
            label: 'Mood',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined, color: Colors.black54),
            selectedIcon: Icon(Icons.analytics, color: Colors.black),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_gymnastics_outlined, color: Colors.black54),
            selectedIcon: Icon(Icons.sports_gymnastics, color: Colors.black),
            label: 'Activities',
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFE0F4FF),
                const Color(0xFFCCE9FF),
              ],
            ),
            border: Border.all(
              color: Colors.black12,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 32,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
