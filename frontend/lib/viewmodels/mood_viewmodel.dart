import 'package:flutter/foundation.dart';
import '../core/services/mood_service.dart';
import '../core/models/mood_entry.dart';

class MoodViewModel extends ChangeNotifier {
  final MoodService _moodService = MoodService();
  List<MoodEntry> _entries = [];
  Map<String, int> _stats = {};
  bool _isLoading = false;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _entries = await _moodService.getMoodEntries();
      _stats = await _moodService.getStats();
    } catch (e) {
      print('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
