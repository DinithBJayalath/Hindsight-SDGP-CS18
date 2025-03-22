import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'API_Service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JournalProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _journalEntries = [];
  final ApiService _apiService =
      ApiService(baseUrl: dotenv.env['API_URL'] ?? '');
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _isInitialized = false;

  List<Map<String, dynamic>> get journalEntries => _journalEntries;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  // Initialize journals from backend
  Future<void> initJournals() async {
    if (_isInitialized) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.getData('moodcheck/journals', requireAuth: true);

      if (response != null) {
        _journalEntries.clear();

        // Handle the response which might be a list or have a 'data' property
        final List<dynamic> journals =
            response is List ? response : response['data'] ?? [];

        for (var journal in journals) {
          _journalEntries.add({
            'title': journal['journalTitle'] ?? 'Untitled',
            'content': journal['journalContent'] ?? '',
            'date': journal['createdAt'] != null
                ? DateTime.parse(journal['createdAt']).toString()
                : DateTime.now().toString(),
            'emotion': journal['emotion'] ?? 'neutral',
            'mood': journal['mood'] ?? 'neutral',
            'sentiment': journal['sentiment'] ?? 0.0,
            'factors': journal['factors'] ?? [],
            'id': journal['_id'] ?? ''
          });
        }
      }

      _isInitialized = true;
    } catch (e) {
      print('Error loading journals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new journal entry
  void addJournalEntry(String title, String content, String emotion,
      String mood, double sentiment,
      {List<String> factors = const []}) {
    final now = DateTime.now();

    // Add to local storage first
    _journalEntries.insert(0, {
      'title': title,
      'content': content,
      'date': now.toString(),
      'emotion': emotion,
      'mood': mood,
      'sentiment': sentiment,
      'factors': factors
    });

    notifyListeners();
  }

  // Update an existing entry
  void updateJournalEntry(int index, String title, String content,
      String emotion, String mood, double sentiment,
      {List<String> factors = const []}) {
    if (index >= 0 && index < _journalEntries.length) {
      _journalEntries[index] = {
        ..._journalEntries[index],
        'title': title,
        'content': content,
        'emotion': emotion,
        'mood': mood,
        'sentiment': sentiment,
        'factors': factors,
      };

      notifyListeners();
    }
  }

  // Delete an entry
  void deleteJournalEntry(int index) {
    if (index >= 0 && index < _journalEntries.length) {
      final entryId = _journalEntries[index]['id'];
      _journalEntries.removeAt(index);

      // If the entry has an ID, delete it from the backend
      if (entryId != null && entryId.isNotEmpty) {
        _apiService.getData('moodcheck/entry/$index', requireAuth: true);
      }

      notifyListeners();
    }
  }
}
