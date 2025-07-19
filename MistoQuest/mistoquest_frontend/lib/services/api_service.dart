import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mistoquest_frontend/models/challenge.dart';
import '../config.dart';


class ApiService {
  final http.Client _client;
  final String _baseUrl = apiBaseUrl;

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  ApiService({http.Client? client}) : _client = client ?? http.Client();

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
    final response = await _client.post(Uri.parse('$_baseUrl/challenges'),
      headers: _headers,
      body: jsonEncode(challengeData),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Challenge.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create challenge: ${response.body}');
  }

  // PUT request to update a challenge
  Future<Challenge> updateChallenge(int id, Map<String, dynamic> challengeData) async {
    final response = await _client.put(Uri.parse('$_baseUrl/challenges/$id'),
      headers: _headers,
      body: jsonEncode(challengeData),
    );
    if (response.statusCode == 200) {
      return Challenge.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update challenge: ${response.body}');
  }

  // GET request to fetch challenges for a specific user (user_id is hardcoded for now)
  Future<List<UserChallenge>> fetchUserChallenges({int userId = 1}) async {
    final response = await _client.get(Uri.parse('$_baseUrl/user/$userId/challenges/'));
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

  // POST request to mark a challenge as completed
  Future<bool> completeChallenge(int userId, int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/user/complete_challenge'),
      headers: _headers,
      body: jsonEncode({
        'id_user': userId,
        'id_challenge': challengeId,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Failed to complete challenge: ${response.body}');
  }

// POST request to mark a challenge as terminated
  Future<bool> terminateChallenge(int userId, int challengeId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/user/terminate_challenge'),
      headers: _headers,
      body: jsonEncode({
        'id_user': userId,
        'id_challenge': challengeId,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Failed to terminate challenge: ${response.body}');
  }
}