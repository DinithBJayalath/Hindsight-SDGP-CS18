import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../Core/Models/Emotion.dart';

class EmotionsProvider extends ChangeNotifier {
  final List<Emotion> _allEmotions = [];

  // Getter for all emotions
  List<Emotion> get allEmotions => _allEmotions;

  // Getter for today's emotions
  List<Emotion> get todayEmotions =>
      _allEmotions.where((emotion) => emotion.isToday).toList();

  // Getter for unique emotions today (for the jar)
  List<Emotion> get uniqueTodayEmotions {
    final uniqueEmotionIds = <String>{};
    final uniqueEmotions = <Emotion>[];

    for (final emotion in todayEmotions) {
      if (!uniqueEmotionIds.contains(emotion.id)) {
        uniqueEmotionIds.add(emotion.name);
        uniqueEmotions.add(emotion);
      }
    }

    return uniqueEmotions;
  }

  // Add a new emotion
  void addEmotion(String name, String emoji) {
    final newEmotion = Emotion(
      id: const Uuid().v4(),
      name: name,
      emoji: emoji,
      timestamp: DateTime.now(),
    );

    _allEmotions.add(newEmotion);
    notifyListeners();
  }

  // Add multiple emotions at once
  void addEmotions(List<Map<String, String>> emotions) {
    final now = DateTime.now();

    for (final emotion in emotions) {
      final newEmotion = Emotion(
        id: const Uuid().v4(),
        name: emotion['name'] ?? '',
        emoji: emotion['emoji'] ?? '',
        timestamp: now,
      );

      _allEmotions.add(newEmotion);
    }

    notifyListeners();
  }

  // Clear all emotions (for testing)
  void clearEmotions() {
    _allEmotions.clear();
    notifyListeners();
  }

  void removeEmotion(int index) {
    _allEmotions.removeAt(index); // TODO: not working, check
    notifyListeners();
  }
}