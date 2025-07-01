import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mistoquest_frontend/models/challenge.dart';


class ApiService {
  final String _baseUrl = 'http://10.0.2.2:8000';

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
}
