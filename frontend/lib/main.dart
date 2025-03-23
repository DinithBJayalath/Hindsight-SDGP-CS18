import 'package:flutter/material.dart';
import 'package:frontend/services/API_Service.dart';
import 'package:frontend/services/Journal_Provider.dart';
import 'screens/home_screen.dart';
import 'services/Emotions_Provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  final apiService = ApiService(baseUrl: 'https://your-backend-url.com/api');
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EmotionsProvider(apiService: apiService)),
    ChangeNotifierProvider(create: (_) => JournalProvider())
  ], child: const HindsightApp()));
}

class HindsightApp extends StatelessWidget {
  const HindsightApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HindSight',
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
      },
      home: const SplashScreen(),
    );
  }
}
