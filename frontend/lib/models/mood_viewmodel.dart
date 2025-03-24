// lib/models/viewmodel.dart

import 'package:flutter/foundation.dart';
import '../services/mood_service.dart';
import '../models/mood_entry.dart';

class MoodViewModel extends ChangeNotifier {
  final MoodService _moodService = MoodService();

  final String userId = "67dd966335499a3e6c077709";

  List<MoodEntry> _entries = [];
  bool _isLoading = false;

  List<MoodEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  // Only load data from the server
  Future<void> loadData({DateTime? start, DateTime? end}) async {
    _isLoading = true;
    notifyListeners();
    try {
      // example default range = last 30 days
      final now = DateTime.now();
      final defaultStart = now.subtract(const Duration(days: 30));
      final defaultEnd = now.add(const Duration(days: 30));

      _entries = await _moodService.getMoodEntries(
        userId: userId,
        start: start ?? defaultStart,
        end: end ?? defaultEnd,
      );
    } catch (e) {
      print('Error loading moods: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
