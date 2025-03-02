import 'package:flutter/material.dart';
import 'journaling_screen.dart';
import '../widgets/custom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const JournalingScreen(),
    const MoodCheckInScreen(),
    const ActivityRecommendationsScreen(),
    const MoodDashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen'),
    );
  }
}

// Placeholder screens (these will be replaced with actual screen implementations)
class MoodCheckInScreen extends StatelessWidget {
  const MoodCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mood Check-In Screen'),
    );
  }
}

class ActivityRecommendationsScreen extends StatelessWidget {
  const ActivityRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Activity Recommendations Screen'),
    );
  }
}

class MoodDashboardScreen extends StatelessWidget {
  const MoodDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mood Dashboard Screen'),
    );
  }
}
