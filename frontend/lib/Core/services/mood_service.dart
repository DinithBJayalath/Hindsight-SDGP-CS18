import '../models/mood_entry.dart';

class MoodService {
  List<MoodEntry> _moodEntries = [];

  Future<List<MoodEntry>> getMoodEntries() async {
    // Simulate API call or database fetch
    await Future.delayed(const Duration(milliseconds: 300));
    return _moodEntries;

