import 'package:flutter/material.dart';

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
                    color: Color(0xFF2E3E5C),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Choose an activity to help improve your mental wellbeing',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Color(0xFF8F9BB3),
                  ),
                ),
                const SizedBox(height: 40),
                ActivityCard(
                  title: 'Deep Breathing',
                  description:
                      'A guided breathing activity that helps you reduce stress, improve focus, and calm your mind.',
                  icon: Icons.air,
                  color: const Color(0xFFE0F4FF),
                  iconColor: const Color(0xFF4A97E9),
                  onTap: () => _handleActivityTap('Deep Breathing'),
                ),
                const SizedBox(height: 16),
                ActivityCard(
                  title: 'Expressive Art',
                  description:
                      'A digital canvas for you to draw or doodle your emotions.',
                  icon: Icons.palette,
                  color: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFFF9800),
                  onTap: () => _handleActivityTap('Expressive Art'),
                ),
                const SizedBox(height: 16),
                ActivityCard(
                  title: 'Letter to Future Self',
                  description:
                      'Write a letter to yourself, set a future date, and receive the letter as a reminder.',
                  icon: Icons.mail,
                  color: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF66BB6A),
                  onTap: () => _handleActivityTap('Letter to Future Self'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.mood_outlined),
            selectedIcon: Icon(Icons.mood),
            label: 'Mood',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_gymnastics_outlined),
            selectedIcon: Icon(Icons.sports_gymnastics),
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
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: iconColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: iconColor.withOpacity(0.5),
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
                  color: Color(0xFF2E3E5C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: const Color(0xFF2E3E5C).withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
