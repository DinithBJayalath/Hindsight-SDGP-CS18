import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import  'viewmodels/mood_viewmodel.dart';
import 'views/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoodViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,  // This removes the debug banner
        title: 'Mood Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}