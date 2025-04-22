import '../Core/Models/Emotion.dart';
import 'activities_screen.dart';
import 'dashboard_screen.dart';
import 'quick_mood.dart';
import '../services/Emotions_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'journaling_screen.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/mood_jar.dart';
import 'profile_screen.dart';
import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<_HomeContentState> _homeContentKey = GlobalKey();

  final List<Widget> _screens = [
    HomeContent(),
    JournalingScreen(),
    MoodTrackerScreen(),
    ActivitiesScreen(),
    DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == 1 && index == 0) {
      // Update the emotions jar when returning to home
      _homeContentKey.currentState?.updateEmotions();
    }
    if (index == 0) {
      // Reload the username when returning to home
      _homeContentKey.currentState?._loadUserName();
    }
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
  final AuthService _authService = AuthService();
  String _userName = "User"; // Default username
  // This is the shared instance of the provider
  late EmotionsProvider _emotionsProvider;
  List<Emotion> _uniqueEmotions = [];
  bool _isAddingEmotions = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final storedName = await _storage.read(key: 'user_name');
      if (storedName != null && storedName.isNotEmpty) {
        setState(() {
          _userName = storedName;
        });
      }
    } catch (e) {
      print('Error loading username: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the provider
    _emotionsProvider = Provider.of<EmotionsProvider>(context, listen: false);
    // Get the initial emotions
    updateEmotions();

    // If you want to listen for changes, you can add a listener
    _emotionsProvider.addListener(updateEmotions);
  }

  void updateEmotions() {
    setState(() {
      _uniqueEmotions = _emotionsProvider.uniqueTodayEmotions;
      for (var emotion in _uniqueEmotions) {}

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _addEmotionsToJar();
      });
    });
  }

  Future<void> _addEmotionsToJar() async {
    // if (_isAddingEmotions) return;
    // _isAddingEmotions = true;
    // Add each emotion to the jar
    for (var emotion in _uniqueEmotions) {
      await _moodJarKey.currentState?.addMoodFromText(emotion.name);
    }
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    _emotionsProvider.removeListener(updateEmotions);
    super.dispose();
  }

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

  void _navigateToProfile() async {
    final userInfo = await _authService.getUserProfile();
    if (userInfo.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(userInfo: userInfo)),
      );
      // Reload the username when returning from profile screen
      _loadUserName();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user profile')),
      );
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 16) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
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
                            '${getGreeting()}',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 157, 255),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _navigateToProfile,
                        child: CircleAvatar(
                          radius: 20, // Placeholder icon
                          backgroundColor:
                              const Color.fromARGB(255, 68, 183, 255),
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
                  //_buildMoodSelectionSection(),

                  const SizedBox(height: 10),

                  // Last seven days calendar (improved)
                  _buildLastSevenDaysCalendar(),

                  const SizedBox(height: 20),

                  // MoodTrackingWidget(
                  //   moodData: [
                  //     MoodData('Awful', 1, const Color(0xFFB668D2), '😫'),
                  //     MoodData('Bad', 1, const Color(0xFF6B88E8), '😢'),
                  //     MoodData('Neutral', 1, const Color(0xFF5ECCE6), '😐'),
                  //     MoodData('Good', 2, const Color(0xFF5ED48C), '😊'),
                  //     MoodData('Great', 2, const Color(0xFFF87D7D), '😄'),
                  //   ],
                  // ),

                  // const SizedBox(height: 20),

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
    final quotes = [
      "Take a deep breath and start again.",
      "Your mind is a powerful thing. When you fill it with positive thoughts, your life will start to change.",
      "Mental health is not a destination, but a process. It's about how you drive, not where you're going.",
      "You don't have to control your thoughts. You just have to stop letting them control you.",
      "Happiness can be found even in the darkest of times, if one only remembers to turn on the light."
    ];

    final today = DateTime.now().day;
    final quote = quotes[today % quotes.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 190, 230, 255),
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
        children: [
          Text(
            '"$quote"',
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Mental Health Journal',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
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
        color: const Color.fromARGB(255, 190, 230, 255),
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
                      width: 30,
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
}

class MoodTrackingWidget extends StatelessWidget {
  final List<MoodData> moodData;

  const MoodTrackingWidget({super.key, required this.moodData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 190, 230, 255),
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
                  title: data.count > 0
                      ? '${(data.count / totalMoods * 100).toStringAsFixed(1)}%'
                      : '',
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
    return Column(
      children: moodData.map((data) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Use Flexible for the left side with the emoji
            Flexible(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: data.color,
                  ),
                  const SizedBox(width: 4),
                  Text(data.emoji, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
            // Add some spacing
            const SizedBox(width: 8),
            // Use Flexible for the text as well to ensure it doesn't overflow
            Flexible(
              child: Text(
                '${data.mood} (${data.count})',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
