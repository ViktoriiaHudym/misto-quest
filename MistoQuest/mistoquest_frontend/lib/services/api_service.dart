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

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<int?> getUserIdFromToken() async {
    String? token = await _getToken();
    if (token == null) return null;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    return payload['user_id'];
  }

  Future<List<Challenge>> fetchChallenges() async {
    final response = await _client.get(Uri.parse('$_baseUrl/challenges/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Challenge.fromJson(json)).toList();
    }
    throw Exception('Failed to load challenges: ${response.statusCode}');
  }

  Future<bool> acceptUserChallenge(int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/challenges/$challengeId/accept/'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 201) return true;
    if (response.statusCode == 400) return false;
    throw Exception('Failed to accept challenge: ${response.body}');
  }

  Future<bool> startUserChallenge(int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/users/start_challenge/'),
      headers: await _authHeaders(),
      body: jsonEncode({'id_challenge': challengeId}),
    );
    if (response.statusCode == 200) return true;
    throw Exception('Failed to start challenge: ${response.body}');
  }

  Future<List<UserChallenge>> fetchUserChallenges() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/users/my_challenges/'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => UserChallenge.fromJson(json)).toList();
    }
    throw Exception('Failed to load participating challenges: ${response.body}');
  }

  Future<bool> completeChallenge(int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/users/complete_challenge/'),
      headers: await _authHeaders(),
      body: jsonEncode({'id_challenge': challengeId}),
    );
    if (response.statusCode == 200) return true;
    throw Exception('Failed to complete challenge: ${response.body}');
  }

  Future<bool> terminateChallenge(int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/users/terminate_challenge/'),
      headers: await _authHeaders(),
      body: jsonEncode({'id_challenge': challengeId}),
    );
    if (response.statusCode == 200) return true;
    throw Exception('Failed to terminate challenge: ${response.body}');
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );
    if (response.statusCode == 201) return true;
    return false;
  }
}