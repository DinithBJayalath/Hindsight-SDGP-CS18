import 'package:flutter/material.dart';
import 'journaling_screen.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/mood_jar.dart';

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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final GlobalKey<MoodJarState> _moodJarKey = GlobalKey<MoodJarState>();
  final String _userName = "John"; // This would come from user data

  // Sample emotions for testing
  final List<String> _testEmotions = [
    "happy",
    "sad",
    "angry",
    "calm",
    "anxious",
    "neutral"
  ];
  int _currentEmotionIndex = 0;

  void _addTestEmoji() {
    _moodJarKey.currentState
        ?.addSpecificEmoji(_testEmotions[_currentEmotionIndex]);
    setState(() {
      _currentEmotionIndex = (_currentEmotionIndex + 1) % _testEmotions.length;
    });
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(
          255, 245, 250, 252), // Light blue background like in the image
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Header with greeting and profile photo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _navigateToProfile,
                        child: CircleAvatar(
                          radius: 20, // Placeholder icon
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Jar section directly under the header
                  Center(
                    child: MoodJar(
                      key: _moodJarKey,
                      onJarTap: () {
                        // Show mood history or details when jar is tapped
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Mood history will be shown here')),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Mood selection section
                  _buildMoodSelectionSection(),

                  const SizedBox(height: 10),

                  // Last seven days calendar (improved)
                  _buildLastSevenDaysCalendar(),

                  const SizedBox(height: 10),

                  // Daily Quote
                  _buildDailyQuote(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyQuote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '"The only way to do great work is to love what you do."',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '- Steve Jobs',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastSevenDaysCalendar() {
    final today = DateTime.now();
    final lastSevenDays =
        List.generate(7, (index) => today.subtract(Duration(days: index)));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'January', // Month name
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: lastSevenDays.map((date) {
              return Column(
                children: [
                  Text(
                    '${date.day}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Replace with actual emoji based on mood
                  Text(
                    _getEmojiForDate(date), // Function to get emoji
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  // Add a small description or mood label
                  Text(
                    _getMoodLabelForDate(date), // Function to get mood label
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getEmojiForDate(DateTime date) {
    // Placeholder logic for emoji selection
    // Replace with actual logic to get mood for the date
    return "😊"; // Example emoji
  }

  String _getMoodLabelForDate(DateTime date) {
    // Placeholder logic for mood label selection
    // Replace with actual logic to get mood for the date
    return "Happy"; // Example mood label
  }

  Widget _buildMoodSelectionSection() {
    final moods = [
      {"name": "Awful", "color": const Color(0xFFB668D2), "emoji": "😫"},
      {"name": "Bad", "color": const Color(0xFF6B88E8), "emoji": "😢"},
      {"name": "Neutral", "color": const Color(0xFF5ECCE6), "emoji": "😐"},
      {"name": "Good", "color": const Color(0xFF5ED48C), "emoji": "😊"},
      {"name": "Great", "color": const Color(0xFFF87D7D), "emoji": "😄"},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: moods.map((mood) {
          return GestureDetector(
            onTap: () {
              _moodJarKey.currentState
                  ?.addSpecificEmoji((mood["name"] as String).toLowerCase());
            },
            child: Column(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Text(
                      mood["emoji"] as String,
                      style: TextStyle(
                        fontSize: 36,
                        shadows: [
                          Shadow(
                            color: (mood["color"] as Color).withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mood["name"] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
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

// Placeholder profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
