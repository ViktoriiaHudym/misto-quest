import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mistoquest_frontend/models/challenge.dart';


class ApiService {
  final String _baseUrl = 'http://10.0.2.2:8000';
  final _storage = const FlutterSecureStorage();

  // Method to get the stored token
  Future<String?> _getToken() async {
    return await _storage.read(key: 'access_token');
  }

  // GET request to fetch a list of challenges
  Future<List<Challenge>> fetchChallenges() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/challenges'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Convert the JSON data into a list of Challenge objects
        return data.map((json) => Challenge.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load challenges');
      }
    } catch (e) {
      throw Exception('Error fetching challenges: $e');
    }
  }

  // POST request to create a new challenge
  Future<void> createChallenge(Map<String, dynamic> challengeData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/challenges'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(challengeData),
      );

      if (response.statusCode == 201) {
        print('Challenge created successfully!');
      } else {
        throw Exception('Failed to create challenge');
      }
    } catch (e) {
      throw Exception('Error creating challenge: $e');
    }
  }

  // PUT request to update a challenge
  Future<void> updateChallenge(int id, Map<String, dynamic> challengeData) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/challenges/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(challengeData),
      );

      if (response.statusCode == 200) {
        print('Challenge updated successfully!');
      } else {
        throw Exception('Failed to update challenge');
      }
    } catch (e) {
      throw Exception('Error updating challenge: $e');
    }
  }

  // LOGIN METHOD
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
      return true;
    } else {
      print('Login failed! Status: ${response.statusCode}, Body: ${response.body}');
      return false;
    }
  }

  // REGISTER METHOD
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Register failed! Status: ${response.statusCode}, Body: ${response.body}');
      return false;
    }
  }
}
