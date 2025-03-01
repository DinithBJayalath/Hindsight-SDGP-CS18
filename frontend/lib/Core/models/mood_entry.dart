class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5 scale
  final String? note;

  MoodEntry({
    required this.date,
    required this.moodLevel,
    this.note,


  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'moodLevel': moodLevel,
    'note': note,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    date: DateTime.parse(json['date']),
    moodLevel: json['moodLevel'],
    note: json['note'],
  );
}