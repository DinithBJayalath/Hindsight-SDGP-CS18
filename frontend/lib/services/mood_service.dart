import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mood_entry.dart';

class MoodService {
  static const String baseDomain = '172.20.10.3:3000';  // Adjust for production
  static const String basePath = '/api/mood';

  Future<List<MoodEntry>> getMoodEntries({
    required String userId,
    DateTime? start,
    DateTime? end,
  }) async {
    final queryParams = <String, String>{};
    queryParams['userId'] = userId;
    if (start != null) queryParams['start'] = start.toIso8601String();
    if (end != null) queryParams['end'] = end.toIso8601String();

    final uri = Uri.http(baseDomain, basePath, queryParams);

    // **Log the full request URL**
    print("Fetching moods from: $uri");

    try {
      final response = await http.get(uri);
      
      // **Log the response status and body**
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List data = body['data'];
        return data.map((item) => MoodEntry.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load moods: ${response.body}');
      }
    } catch (e) {
      print("Error fetching moods: $e");
      throw Exception('Error fetching moods: $e');
    }
  }
}
