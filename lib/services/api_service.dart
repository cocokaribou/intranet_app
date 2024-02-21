// Import necessary packages
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = "http://13.209.23.94:8000";

  // singleton object
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();

  factory ApiService() {
    return _instance;
  }

  Future<dynamic> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/login');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {'username': username, 'password': password};

    print("아 뭔데.. $username $password");
    String encodedBody = body.keys.map((key) => "$key=${Uri.encodeComponent(body[key]!)}").join("&");

    try {
      final response = await http.post(uri, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        print("여기 아니세요?");
        return jsonDecode(response.body);
      } else {
        // Handle errors or other status codes accordingly
        return Future.error('Failed to login with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      return Future.error('An error occurred during login: $e');
    }
  }

// You can add more methods here for other API calls
}
