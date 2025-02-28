import 'package:flutter/material.dart';
import 'screens/journaling_screen.dart';

void main() {
  runApp(HindSightApp());
}

class HindSightApp extends StatelessWidget {
  const HindSightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HindSight',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
