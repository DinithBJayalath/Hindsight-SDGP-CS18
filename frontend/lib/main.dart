import 'package:flutter/material.dart';
import 'screens/journaling_screen.dart';

void main() {
  runApp(HindsightApp());
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
      ),
      home: JournalingScreen(),
    );
  }
}
