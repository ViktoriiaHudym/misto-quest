import 'package:flutter/material.dart';
// import 'package:mistoquest_frontend/services/api_service.dart';
// import 'package:mistoquest_frontend/models/challenge.dart';

import '../models/challenge.dart';
import '../services/api_service.dart';

class ChallengeListScreen extends StatefulWidget {
  @override
  _ChallengeListScreenState createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen> {
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
        title: Text('Challenges'),
      ),
      body: FutureBuilder<List<Challenge>>(
        future: challenges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No challenges available.'));
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
