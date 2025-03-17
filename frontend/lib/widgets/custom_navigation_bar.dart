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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: NavigationBar(
        height: 60,
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        animationDuration: const Duration(milliseconds: 200),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          _buildDestination(0, Icons.home_outlined, Icons.home, 'Home'),
          _buildDestination(1, Icons.book_outlined, Icons.book, 'Journal'),
          _buildDestination(2, Icons.sentiment_satisfied_outlined,
              Icons.emoji_emotions, 'Mood'),
          _buildDestination(
              3, Icons.lightbulb_outline, Icons.lightbulb, 'Activities'),
          _buildDestination(
              4, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
        ],
      ),
    );
  }

  NavigationDestination _buildDestination(
      int index, IconData icon, IconData selectedIcon, String label) {
    return NavigationDestination(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Icon(
          icon,
          size: 24,
          color: Colors.grey,
        ),
      ),
      selectedIcon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Icon(
          selectedIcon,
          size: 24,
          color: const Color(0xFF8CD3FF),
        ),
      ),
      label: label,
    );
  }
}
