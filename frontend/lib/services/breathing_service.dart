import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/breathing_session.dart';
import 'api_service.dart';

class BreathingService {
  final ApiService _apiService = ApiService();
  final String endpoint = '/breathing';

  Future<List<BreathingSession>> getUserSessions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${_apiService.baseUrl}$endpoint?userId=$userId'),
        headers: _apiService.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => BreathingSession.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load breathing sessions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load breathing sessions: $e');
    }
  }

  Future<BreathingSession> saveSession(BreathingSession session) async {
    try {
      final response = await http.post(
        Uri.parse('${_apiService.baseUrl}$endpoint'),
        headers: _apiService.headers,
        body: json.encode(session.toJson()),
      );

      if (response.statusCode == 201) {
        return BreathingSession.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to save breathing session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to save breathing session: $e');
    }
  }

  Future<BreathingSession> getSession(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${_apiService.baseUrl}$endpoint/$id'),
        headers: _apiService.headers,
      );

      if (response.statusCode == 200) {
        return BreathingSession.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load breathing session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load breathing session: $e');
    }
  }

  Future<void> deleteSession(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${_apiService.baseUrl}$endpoint/$id'),
        headers: _apiService.headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete breathing session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete breathing session: $e');
    }
  }
}
