import 'package:flutter/material.dart';

void main() {
  runApp(const HindSightApp());
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
