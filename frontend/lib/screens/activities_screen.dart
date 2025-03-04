import 'package:flutter/material.dart';
import 'dart:ui';
import 'breathing_exercises_screen.dart';
import 'expressive_art_screen.dart';
import 'future_letters_list_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 4;
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          // Calculate the slide animation value based on scroll position
          final scrollPosition = _scrollController.offset;
          final maxScroll = 300.0; // Height of the header
          final slideValue = (scrollPosition / maxScroll).clamp(0.0, 1.0);
          _slideAnimation = Tween<double>(begin: 0.0, end: -50.0).animate(
            CurvedAnimation(
              parent: AlwaysStoppedAnimation(slideValue),
              curve: Curves.easeOut,
            ),
          );
        });
      });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: AlwaysStoppedAnimation(0.0),
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleActivityTap(String activity) {
    if (activity == 'Deep Breathing') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BreathingExercisesScreen(),
        ),
      );
    } else if (activity == 'Expressive Art') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExpressiveArtScreen(),
        ),
      );
    } else if (activity == 'Letter to Future Self') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FutureLettersListScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening $activity...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE0F4FF),
              const Color(0xFFCCE9FF),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -30,
                          bottom: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Activities',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              AnimatedBuilder(
                                animation: _slideAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_slideAnimation.value, 0),
                                    child: Opacity(
                                      opacity: 1 -
                                          (_slideAnimation.value.abs() / 50),
                                      child: const Text(
                                        'Discover engaging activities designed to enhance your mental wellbeing and personal growth.',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16,
                                          color: Colors.black54,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          onTap: () =>
                              _handleActivityTap('Letter to Future Self'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
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
