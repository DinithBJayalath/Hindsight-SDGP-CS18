import 'package:flutter/material.dart';
import 'journaling_screen.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/mood_jar.dart';
import 'package:fl_chart/fl_chart.dart';

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

                  const SizedBox(height: 20),

                  MoodTrackingWidget(
                    moodData: [
                      MoodData('Good', 3, Colors.green, '😊'),
                      MoodData('Great', 2, Colors.red, '😄'),
                      // Add more moods as needed
                    ],
                  ),

                  const SizedBox(height: 20),

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
            'Last 7 Days', // Title for the section
            style: const TextStyle(
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      // Show popup with larger MoodJar
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'Mood Details for ${date.day}/${date.month}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MoodJar(
                                onJarTap: () {},
                                // Add any additional properties if needed
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Emojis: ${_getEmojisForDate(date)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 30, // Adjusted jar size
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: MoodJar(
                        onJarTap: () {},
                      ),
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

  String _getEmojisForDate(DateTime date) {
    // Placeholder logic for getting emojis
    return "😊, 😢"; // Example emojis
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

class MoodTrackingWidget extends StatelessWidget {
  final List<MoodData> moodData;

  MoodTrackingWidget({required this.moodData});

  @override
  Widget build(BuildContext context) {
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
            'Mood Count',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildDonutChart(),
          const SizedBox(height: 10),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    int totalMoods = moodData.fold(0, (sum, item) => sum + item.count);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: moodData.map((data) {
                return PieChartSectionData(
                  color: data.color,
                  value: data.count.toDouble(),
                  title:
                      '${(data.count / totalMoods * 100).toStringAsFixed(1)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$totalMoods',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Recorded moods'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: moodData.map((data) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: data.color,
                ),
                const SizedBox(width: 4),
                Text(data.emoji),
              ],
            ),
            Text(
              data.mood,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${data.count}'),
          ],
        );
      }).toList(),
    );
  }
}

class MoodData {
  final String mood;
  final int count;
  final Color color;
  final String emoji;

  MoodData(this.mood, this.count, this.color, this.emoji);
}
