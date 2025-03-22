import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/letter.dart';
import 'api_service.dart';

class LetterService {
  final ApiService _apiService = ApiService();
  final String endpoint = '/letters';

  Future<List<Letter>> getUserLetters(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${_apiService.baseUrl}$endpoint?userId=$userId'),
        headers: _apiService.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Letter.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load letters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load letters: $e');
    }
  }

  Future<Letter> saveLetter(Letter letter) async {
    try {
      final response = await http.post(
        Uri.parse('${_apiService.baseUrl}$endpoint'),
        headers: _apiService.headers,
        body: json.encode(letter.toJson()),
      );

      if (response.statusCode == 201) {
        return Letter.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to save letter: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to save letter: $e');
    }
  }

  Future<Letter> getLetter(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${_apiService.baseUrl}$endpoint/$id'),
        headers: _apiService.headers,
      );

      if (response.statusCode == 200) {
        return Letter.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load letter: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load letter: $e');
    }
  }

  Future<void> deleteLetter(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${_apiService.baseUrl}$endpoint/$id'),
        headers: _apiService.headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete letter: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete letter: $e');
    }
  }
}
