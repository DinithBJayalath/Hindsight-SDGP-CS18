import 'package:flutter/material.dart';
import 'screens/activities_screen.dart';

void main() {
  runApp(const HindSightApp());
}

class HindSightApp extends StatelessWidget {
  const HindSightApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HindSight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ActivitiesScreen(),
    );
  }
}
