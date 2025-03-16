import 'package:flutter/material.dart';
import 'package:frontend/services/Journal_Provider.dart';
import 'screens/home_screen.dart';
import 'services/Emotions_Provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => EmotionsProvider()),
            ChangeNotifierProvider(create: (_) => JournalProvider())
          ],
          child: const HindsightApp()
      )
  );
}

class HindsightApp extends StatelessWidget {
  const HindsightApp({super.key});

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
      home: const HomeScreen(),
    );
  }
}
