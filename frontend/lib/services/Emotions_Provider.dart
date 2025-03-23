import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../Core/Models/Emotion.dart';
import '../services/API_Service.dart';

class EmotionsProvider extends ChangeNotifier {
  final List<Emotion> _allEmotions = [];
  final ApiService _apiService;
  bool _isLoading = false;
  String _error = '';

  EmotionsProvider({required ApiService apiService}) : _apiService = apiService {
    // Load emotions when the provider is initialized
    fetchEmotions();
  }

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

  Future<void> fetchEmotions() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _apiService.getData(
        'moodcheck', // Update this endpoint based on your API
        requireAuth: true,
      );

      // Clear existing emotions
      _allEmotions.clear();

      // Parse emotions from response
      if (response.containsKey('emotions') && response['emotions'] is List) {
        for (var emotionData in response['emotions']) {
          final emotion = Emotion(
            id: emotionData['id'] ?? const Uuid().v4(),
            name: emotionData['name'] ?? '',
            emoji: emotionData['emoji'] ?? '',
            timestamp: emotionData['timestamp'] != null
                ? DateTime.parse(emotionData['timestamp'])
                : DateTime.now(),
          );
          _allEmotions.add(emotion);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load emotions: $e';
      notifyListeners();
    }
  }

  Future<void> refreshEmotions() async {
    await fetchEmotions();
  }

  // Clear all emotions (for testing)
  void clearEmotions() {
    _allEmotions.clear();
    notifyListeners();
  }
}