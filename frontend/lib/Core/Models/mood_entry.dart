class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5 scale
  final String? note;

  MoodEntry({
    required this.date,
    required this.moodLevel,
    this.note,
  });