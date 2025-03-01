class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5 scale
  final String? notes;

  MoodEntry({
    required this.date,
    required this.moodLevel,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'moodLevel': moodLevel,
    'note': notes,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    date: DateTime.parse(json['date']),
    moodLevel: json['moodLevel'],
    notes: json['notes'],
  );
}