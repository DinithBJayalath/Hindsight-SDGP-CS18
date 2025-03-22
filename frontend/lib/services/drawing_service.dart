import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/drawing.dart';
import 'api_service.dart';

class DrawingService {
  final ApiService _apiService = ApiService();
  final String endpoint = '/drawings';

  Future<List<Drawing>> getUserDrawings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${_apiService.baseUrl}$endpoint?userId=$userId'),
        headers: _apiService.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Drawing.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load drawings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load drawings: $e');
    }
  }

  Future<Drawing> saveDrawing(Drawing drawing) async {
    try {
      final response = await http.post(
        Uri.parse('${_apiService.baseUrl}$endpoint'),
        headers: _apiService.headers,
        body: json.encode(drawing.toJson()),
      );

      if (response.statusCode == 201) {
        return Drawing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to save drawing: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to save drawing: $e');
    }
  }

  Future<Drawing> getDrawing(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${_apiService.baseUrl}$endpoint/$id'),
        headers: _apiService.headers,
      );

      if (response.statusCode == 200) {
        return Drawing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load drawing: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load drawing: $e');
    }
  }

  Future<void> deleteDrawing(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${_apiService.baseUrl}$endpoint/$id'),
        headers: _apiService.headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete drawing: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete drawing: $e');
    }
  }
}
