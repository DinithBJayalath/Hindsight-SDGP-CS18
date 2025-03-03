import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/models/mood_entry.dart';

class MoodChart extends StatelessWidget {
  final List<MoodEntry> entries;

  const MoodChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: entries.isEmpty
          ? const Center(child: Text('No mood data available'))
          : LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 5,
          gridData: FlGridData(