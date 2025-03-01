import '../models/mood_entry.dart';

class MoodService {
  List<MoodEntry> _moodEntries = [];

  Future<List<MoodEntry>> getMoodEntries() async {
    // Simulate API call or database fetch
    await Future.delayed(const Duration(milliseconds: 300));
    return _moodEntries;
  }

  Future<void> addMoodEntry(MoodEntry entry) async {
    // Simulate API call or database save
    await Future.delayed(const Duration(milliseconds: 300));
    _moodEntries.add(entry);
  }

  Future<Map<String, int>> getStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'checkIns': 6,
      'journaling': 4,
      'goals': 2,
    };
  }
}
