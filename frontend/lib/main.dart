import 'package:flutter/material.dart';
import 'models/mood_viewmodel.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/quick_mood.dart';
import 'services/Emotions_Provider.dart';
import 'services/Journal_Provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EmotionsProvider()),
    ChangeNotifierProvider(create: (_) => JournalProvider()),
    ChangeNotifierProvider(create: (_) => MoodViewModel())
  ], child: const HindsightApp()));
}

class HindsightApp extends StatelessWidget {
  const HindsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HindSight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(userInfo: {}),
        '/home': (context) => const HomeScreen(),
        '/activities': (context) => const ActivitiesScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
