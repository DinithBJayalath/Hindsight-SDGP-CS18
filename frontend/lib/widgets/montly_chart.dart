import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';

class MonthlyChart extends StatelessWidget {
  final DateTime selectedMonth;
  final List<MoodEntry> entries;

  const MonthlyChart({
    Key? key,
    required this.selectedMonth,
    required this.entries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1) Month name, e.g. "May"
    final monthName = DateFormat('MMMM').format(selectedMonth);

    // 2) Filter only entries in this month
    final monthlyEntries = entries.where((e) {
      return e.date.year == selectedMonth.year &&
             e.date.month == selectedMonth.month;
    }).toList();

    // 3) Build FlSpots
    final spots = <FlSpot>[];
    for (final entry in monthlyEntries) {
      final day = entry.date.day;
      final level = _moodToLevel(entry.mood); // 1..5, or 0 if unknown
      if (level >= 1) {
        spots.add(FlSpot(day.toDouble(), level.toDouble()));
      }
    }

    if (spots.isEmpty) {
      return Center(child: Text("No mood data for $monthName"));
    }

    // Sort by day
    spots.sort((a, b) => a.x.compareTo(b.x));
    final minX = spots.first.x;
    final maxX = spots.last.x;

    // For labeling only days we have data
    final dayValues = spots.map((s) => s.x.toInt()).toSet();

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: 1,
        maxY: 5,

        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          verticalInterval: 1,
        ),

        titlesData: FlTitlesData(
          // -------------- LEFT Y-AXIS EMOJI LABELS --------------
          leftTitles: AxisTitles(
            axisNameWidget: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Mood',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            axisNameSize: 30,
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final intVal = value.toInt();
                switch (intVal) {
                  case 1:
                    return const Text('😡', style: TextStyle(fontSize: 20));
                  case 2:
                    return const Text('😢', style: TextStyle(fontSize: 20));
                  case 3:
                    return const Text('😐', style: TextStyle(fontSize: 20));
                  case 4:
                    return const Text('😊', style: TextStyle(fontSize: 20));
                  case 5:
                    return const Text('🤩', style: TextStyle(fontSize: 20));
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),

          // -------------- BOTTOM X-AXIS LABELS --------------
          bottomTitles: AxisTitles(
            axisNameWidget: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                monthName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            axisNameSize: 30,
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final dayInt = value.toInt();
                // Only show days present in the data
                if (dayValues.contains(dayInt)) {
                  return Text(dayInt.toString());
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Hide top and right axes
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

        // -------------- LINE DATA --------------
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  /// Convert string moods -> integer 1..5
  int _moodToLevel(String mood) {
    switch (mood.toLowerCase()) {
      case 'angry':   return 1; 
      case 'sad':     return 2; 
      case 'neutral': return 3; 
      case 'happy':   return 4; 
      case 'excited': return 5; 
      default:        return 0;
}
}
}