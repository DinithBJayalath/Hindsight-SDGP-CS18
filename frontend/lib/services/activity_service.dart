import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity.dart';

class ActivityService {
  static const String baseUrl ='https://hindsight-backend-core-108992851524.asia-south1.run.app'; 

  Future<List<Activity>> getActivities() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/activities'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getActivities: $e');
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<Activity> getActivityById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/activities/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Activity.fromJson(data);
      } else {
        throw Exception('Failed to load activity');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }
}
