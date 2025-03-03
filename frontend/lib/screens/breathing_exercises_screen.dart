import 'package:flutter/material.dart';
import 'dart:ui';
import 'breathing_player_screen.dart';

class BreathingExercise {
  final String title;
  final String description;
  final String duration;
  final String audioPath;

  BreathingExercise({
    required this.title,
    required this.description,
    required this.duration,
    required this.audioPath,
  });
}

class BreathingExercisesScreen extends StatefulWidget {
  const BreathingExercisesScreen({super.key});

  @override
  State<BreathingExercisesScreen> createState() =>
      _BreathingExercisesScreenState();
}

class _BreathingExercisesScreenState extends State<BreathingExercisesScreen> {
  final List<BreathingExercise> exercises = [
    BreathingExercise(
      title: 'Box Breathing',
      description:
          'A simple technique to reduce stress and anxiety by breathing in a square pattern.',
      duration: '5 minutes',
      audioPath: 'assets/audio/box_breathing.mp3',
    ),
    BreathingExercise(
      title: '4-7-8 Breathing',
      description:
          'A relaxing breathing technique that helps you fall asleep faster.',
      duration: '10 minutes',
      audioPath: 'assets/audio/478_breathing.mp3',
    ),
    BreathingExercise(
      title: 'Diaphragmatic Breathing',
      description:
          'Deep breathing exercise to improve oxygen flow and reduce tension.',
      duration: '8 minutes',
      audioPath: 'assets/audio/diaphragmatic_breathing.mp3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE0F4FF),
              const Color(0xFFCCE9FF),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: false,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Deep Breathing',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Choose a breathing exercise to begin your journey to calmness.',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...exercises.map((exercise) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ExerciseCard(exercise: exercise),
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final BreathingExercise exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFE0F4FF),
                const Color(0xFFCCE9FF),
              ],
            ),
            border: Border.all(
              color: Colors.black12,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BreathingPlayerScreen(
                      exercise: exercise,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.self_improvement,
                            size: 32,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.title,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                exercise.duration,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.play_circle_outline,
                          size: 32,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        exercise.description,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
