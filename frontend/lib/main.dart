import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HindsightApp());
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
