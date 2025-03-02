import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF8CD3FF)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book, color: Color(0xFF8CD3FF)),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.sentiment_satisfied_outlined),
            selectedIcon: Icon(Icons.emoji_emotions, color: Color(0xFF8CD3FF)),
            label: 'Mood',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb, color: Color(0xFF8CD3FF)),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF8CD3FF)),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
