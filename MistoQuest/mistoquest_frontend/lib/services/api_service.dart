import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../models/challenge.dart';
import '../config.dart';


class ApiService {
  final http.Client _client;
  final String _baseUrl = apiBaseUrl;
  final _storage = const FlutterSecureStorage();

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  ApiService({http.Client? client}) : _client = client ?? http.Client();

    // Method to get the stored token
  Future<String?> _getToken() async {
    return await _storage.read(key: 'access_token');
  }

  // GET request to fetch a list of challenges
  Future<List<Challenge>> fetchChallenges() async {
    final response = await _client.get(Uri.parse('$_baseUrl/challenges'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Challenge.fromJson(json)).toList();
    }
    throw Exception('Failed to load challenges: ${response.statusCode}');
  }

  // POST request to create a new challenge
  Future<Challenge> createChallenge(Map<String, dynamic> challengeData) async {
    final response = await _client.post(Uri.parse('$_baseUrl/challenges/create/'),
      headers: _headers,
      body: jsonEncode(challengeData),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Challenge.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create challenge: ${response.body}');
  }

  // PUT request to update a challenge
  Future<Challenge> updateChallenge(int challengeId, Map<String, dynamic> challengeData) async {
    final response = await _client.put(Uri.parse('$_baseUrl/challenges/$challengeId/update/'),
      headers: _headers,
      body: jsonEncode(challengeData),
    );
    if (response.statusCode == 200) {
      return Challenge.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update challenge: ${response.body}');
  }

  // Helper to get userId from JWT
  Future<int?> getUserIdFromToken() async {
    String? token = await _getToken();
    if (token == null) return null;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    return payload['user_id'] ?? payload['id'];
  }

  // Helper to get headers with Authorization
  Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET request to fetch challenges for the authenticated user
  Future<List<UserChallenge>> fetchUserChallenges() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/challenges/user/'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((json) => UserChallenge.fromJson(json)).toList();
      } else if (data is Map && data.containsKey('message')) {
        // No challenges found for user
        return [];
      }
    }
    throw Exception('Failed to load user challenges: ${response.statusCode}');
  }

  // GET request to fetch a single challenge by its ID
  Future<Challenge> fetchChallengeById(int challengeId) async {
    final response = await _client.get(Uri.parse('$_baseUrl/challenges/$challengeId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Challenge.fromJson(data);
    }
    throw Exception('Failed to load challenge: ${response.statusCode}');
  }

  // POST request to mark a challenge as completed (no userId in body)
  Future<bool> completeChallenge(int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/challenges/user/complete_challenge'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'id_challenge': challengeId,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Failed to complete challenge: ${response.body}');
  }

  // POST request to mark a challenge as terminated (no userId in body)
  Future<bool> terminateChallenge(int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/challenges/user/terminate_challenge'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'id_challenge': challengeId,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Failed to terminate challenge: ${response.body}');
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
      // print('Login failed! Status: ${response.statusCode}, Body: ${response.body}');
      return false;
    }
  }

  // REGISTER METHOD
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/profile/'),
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
      // print('Register failed! Status: ${response.statusCode}, Body: ${response.body}');
      return false;
    }
  }
}