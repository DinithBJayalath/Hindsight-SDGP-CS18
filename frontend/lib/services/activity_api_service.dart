import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiActivityService {
  //final String baseUrl = 'https://hindsight-backend-core-108992851524.asia-south1.run.app'; // Android emulator localhost
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Add authentication headers when needed
  Map<String, String> getAuthHeaders(String token) {
    return {
      ...headers,
      'Authorization': 'Bearer $token',
    };
  }
}
