import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/challenge.dart';
import '../widgets/challenge_card.dart';


class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({super.key});

  @override
  ChallengeListScreenState createState() => ChallengeListScreenState();
}

class ChallengeListScreenState extends State<ChallengeListScreen> {
  late ApiService apiService;
  late Future<List<Challenge>> challenges;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    challenges = apiService.fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
      ),
      body: FutureBuilder<List<Challenge>>(
        future: challenges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No challenges available.'));
          } else {
            final challengeList = snapshot.data!;
            return ListView.builder(
              itemCount: challengeList.length,
              itemBuilder: (context, index) {
                final challenge = challengeList[index];

                return ChallengeCard(
                  challenge: challenge,
                  onAccept: () async {
                    final api = ApiService();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Accepting challenge...'))
                    );
                    try {
                      final success = await api.acceptUserChallenge(challenge.id);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? 'Challenge accepted!' : 'Already accepted!'),
                          backgroundColor: success ? Colors.green : Colors.orange,
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red)
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
