import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final Map<String, int> stats;

  const StatsCard({Key? key, required this.stats}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Check-ins', stats['checkIns'] ?? 0),
            _buildStatItem('Journaling', stats['journaling'] ?? 0),
            _buildStatItem('Goals', stats['goals'] ?? 0),
          ],
        ),
      ),
    );
  }