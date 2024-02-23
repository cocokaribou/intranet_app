// Import necessary packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intranet_app/models/Employee.dart';
import 'package:intranet_app/utils/Constants.dart';

import '../models/Resource.dart';

class ApiService {
  // login token
  // remove when logout
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  String? get token => _token;

  // singleton object
  ApiService._privateConstructor();

  static final ApiService _instance = ApiService._privateConstructor();

  factory ApiService() {
    return _instance;
  }

  /// login api
  Future<dynamic> login(String username, String password) async {
    final uri = Uri.parse(Constants.loginEndpoint);
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {'username': username, 'password': password};

    String encodedBody = body.keys
        .map((key) => "$key=${Uri.encodeComponent(body[key]!)}")
        .join("&");

    try {
      final response =
          await http.post(uri, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final object = jsonDecode(response.body);

        setToken(object['access_token']);
        return object;
      } else {
        // Handle errors or other status codes accordingly
        return Future.error(
            'Failed to login with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      return Future.error('An error occurred during login: $e');
    }
  }

  /// user api
  Future<List<Employee>> fetchEmployees() async {
    final url = Uri.parse('${Constants.userEndpoint}/${Constants.listPath}');
    final response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<Employee> employees =
          body.map((dynamic item) => Employee.fromJson(item)).toList();
      return employees;
    } else {
      throw Exception(
          'Failed to load employees. Status code: ${response.statusCode}');
    }
  }

  /// resource api
  Future<List<List<Resource>>> fetchResources() async {
    final url =
        Uri.parse('${Constants.resourceEndpoint}/20/${Constants.listPath}');
    final response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List<List<Resource>> resources = jsonResponse.map<List<Resource>>((list) {
        return list
            .map<Resource>((item) => Resource.fromJson(item, 0))
            .toList();
      }).toList();

      return resources;
    } else {
      throw Exception(
          'Failed to load resources. Status code: ${response.statusCode}');
    }
  }
}
