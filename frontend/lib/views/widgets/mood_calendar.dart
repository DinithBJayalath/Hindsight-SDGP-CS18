import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/models/mood_entry.dart';

class MoodCalendar extends StatefulWidget {
  final List<MoodEntry> entries;

  const MoodCalendar({super.key, required this.entries});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Ensure focusedDay is within the valid range
    _focusedDay = DateTime.utc(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
