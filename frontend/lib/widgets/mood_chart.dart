// lib/widgets/mood_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodChart extends StatelessWidget {
  final List<MoodEntry> entries;

  const MoodChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text('No mood data available'));
    }

    return LineChart(
      LineChartData(
        // Your chart logic here.
        // Possibly you transform each string mood to a numeric scale or skip entirely
        // ...
        lineBarsData: [
          LineChartBarData(
            spots: _getSpotsFromMoods(),
            // ...
          ),
        ],
      ),
    );
  }

  // Example: convert mood strings to a numeric scale for charting
  List<FlSpot> _getSpotsFromMoods() {
    // Sort by date
    final sorted = List<MoodEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // map mood strings to numeric values
    int _mapMoodToValue(String mood) {
      switch (mood) {
        // If this is supposed to be the mood that comes from database -> backend, then double check the moods
        case 'happy': return 4;
        case 'excited': return 5;
        case 'neutral': return 3;
        case 'sad': return 2;
        case 'angry': return 1;
        default: return 0;
      }
    }

    return sorted.asMap().entries.map((e) {
      final index = e.key;
      final moodVal = _mapMoodToValue(e.value.mood);
      return FlSpot(index.toDouble(), moodVal.toDouble());
    }).toList();
  }
}
