class Emotion {
  final String id;
  final String name;
  final String emoji;
  final DateTime timestamp;

  Emotion({
    required this.id,
    required this.name,
    required this.emoji,
    required this.timestamp,
  });

  // Helper to check if emotion is from today
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }
}