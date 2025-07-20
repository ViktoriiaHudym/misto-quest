import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/challenge.dart';


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
                return ListTile(
                  title: Text(challenge.title),
                  subtitle: Text(challenge.description),
                  trailing: Text('${challenge.points} pts'),
                  // onTap: () {
                  //   // Navigate to challenge detail screen (if necessary)
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ChallengeDetailScreen(challengeId: challenge.id),
                  //     ),
                  //   );
                  // },
                );
              },
            );
          }
        },
      ),
    );
  }
}
