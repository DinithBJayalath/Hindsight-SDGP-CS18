import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost

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
