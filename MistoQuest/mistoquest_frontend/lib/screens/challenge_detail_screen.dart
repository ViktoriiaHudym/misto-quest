// import 'package:flutter/material.dart';
// import 'package:mistoquest_frontend/services/api_service.dart';
// import 'package:mistoquest_frontend/models/challenge.dart';
//
// class ChallengeDetailScreen extends StatefulWidget {
//   final int challengeId;
//
//   ChallengeDetailScreen({required this.challengeId});
//
//   @override
//   _ChallengeDetailScreenState createState() => _ChallengeDetailScreenState();
// }
//
// class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
//   late ApiService apiService;
//   late Future<Challenge> challenge;
//
//   @override
//   void initState() {
//     super.initState();
//     apiService = ApiService();
//     challenge = fetchChallengeDetail();
//   }
//
//   // Fetch challenge data by ID
//   Future<Challenge> fetchChallengeDetail() async {
//     final response = await apiService.fetchChallenges();
//     final challengeData = response.firstWhere((data) => data['id'] == widget.challengeId);
//     return Challenge.fromJson(challengeData);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Challenge Details'),
//       ),
//       body: FutureBuilder<Challenge>(
//         future: challenge,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('No data found'));
//           } else {
//             final challengeData = snapshot.data!;
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     challengeData.title,
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   SizedBox(height: 10),
//                   Text(challengeData.description),
//                   SizedBox(height: 10),
//                   Text('Points: ${challengeData.points}'),
//                   SizedBox(height: 10),
//                   Text('Duration: ${challengeData.maxDuration} days'),
//                   SizedBox(height: 10),
//                   Text('Difficulty: ${challengeData.difficulty}'),
//                   SizedBox(height: 10),
//                   Text('Created on: ${challengeData.createdDate.toLocal()}'),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
