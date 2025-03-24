// lib/models/mood_entry.dart

class MoodEntry {
  final DateTime date;
  final String mood;      // e.g. "happy", "sad", etc.
  final String? note;

  MoodEntry({
    required this.date,
    required this.mood,
    this.note,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      date: DateTime.parse(json['date']),
      mood: json['mood'] ?? '',
      note: json['note'],
    );
  }
}
