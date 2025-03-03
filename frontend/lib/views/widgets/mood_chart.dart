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
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value >= 0 && value < days.length) {
                    return Text(days[value.toInt()]);
                  }
                  return const Text('');
                },
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
                interval: 1,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.shade300),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _getChartData(),
              isCurved: true,
              color: Colors.purple,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.purple.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getChartData() {
    if (entries.isEmpty) {
      return [];
    }

    // Sort entries by date
    final sortedEntries = List<MoodEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Get the last 7 days of entries
    final last7Days = sortedEntries.reversed.take(7).toList().reversed.toList();

    // Create spots for the chart
    return last7Days.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.moodLevel.toDouble(),
      );
    }).toList();
  }
}

// Add this to your DashboardScreen widget to test the chart
List<MoodEntry> testData = [
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 6)), moodLevel: 3),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 5)), moodLevel: 4),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 4)), moodLevel: 2),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 3)), moodLevel: 5),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 2)), moodLevel: 3),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 1)), moodLevel: 4),
  MoodEntry(date: DateTime.now(), moodLevel: 5),
];