import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/challenge.dart';

const userStatusChoices = [
  'Not Started',
  'In Progress',
  'Completed',
  'Failed',
  'Terminated',
];

Color getStatusColor(int status) {
  switch (status) {
    case 1: // In Progress
      return Colors.yellow.shade700;
    case 2: // Completed
      return Colors.green.shade400;
    case 3: // Failed
    case 4: // Terminated
      return Colors.grey.shade500;
    default: // Not Started
      return Colors.blue.shade300;
  }
}

class UserParticipationScreen extends StatefulWidget {
  static const String routeName = '/user_participation';
  const UserParticipationScreen({Key? key}) : super(key: key);

  @override
  State<UserParticipationScreen> createState() => _UserParticipationScreenState();
}

class _UserParticipationScreenState extends State<UserParticipationScreen> {
  late Future<List<UserChallenge>> _userChallengesFuture;
  int? _selectedStatusFilter;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _userChallengesFuture = _apiService.fetchUserChallenges();
  }

  // Helper function to reduce repeated code
  Future<void> _handleChallengeAction({
    required Future<bool> Function() apiCall,
    required String successMessage,
    required String errorMessage,
  }) async {
    try {
      final success = await apiCall();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? successMessage : 'Action failed. Please try again.'),
          backgroundColor: success ? Colors.green : Colors.orange,
        ),
      );

      if (success) {
        setState(() {
          _userChallengesFuture = _apiService.fetchUserChallenges();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startChallenge(int challengeId) => _handleChallengeAction(
    apiCall: () => _apiService.startUserChallenge(challengeId),
    successMessage: 'Challenge started!',
    errorMessage: 'Failed to start challenge',
  );

  Future<void> _markAsCompleted(int challengeId) => _handleChallengeAction(
    apiCall: () => _apiService.completeChallenge(challengeId),
    successMessage: 'Challenge completed!',
    errorMessage: 'Failed to complete challenge',
  );

  Future<void> _stopParticipation(int challengeId) => _handleChallengeAction(
    apiCall: () => _apiService.terminateChallenge(challengeId),
    successMessage: 'Participation stopped.',
    errorMessage: 'Failed to stop participation',
  );

  List<UserChallenge> _filterChallenges(List<UserChallenge> challenges) {
    if (_selectedStatusFilter == null) return challenges;
    return challenges.where((c) => c.userCompleteStatus == _selectedStatusFilter).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Statuses'),
                leading: Radio<int?>(
                  value: null,
                  groupValue: _selectedStatusFilter,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedStatusFilter = value;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ...List.generate(userStatusChoices.length, (index) {
                return ListTile(
                  title: Text(userStatusChoices[index]),
                  leading: Radio<int?>(
                    value: index,
                    groupValue: _selectedStatusFilter,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedStatusFilter = value;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Participating Challenges'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter by status',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _userChallengesFuture = _apiService.fetchUserChallenges();
          });
        },
        child: FutureBuilder<List<UserChallenge>>(
          future: _userChallengesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No participating challenges.'));
            } else {
              final userChallenges = _filterChallenges(snapshot.data!);

              if (userChallenges.isEmpty) {
                return const Center(
                  child: Text('No challenges match the selected filter.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: userChallenges.length,
                itemBuilder: (context, index) {
                  final userChallenge = userChallenges[index];
                  final challenge = userChallenge.challenge;
                  final status = userChallenge.userCompleteStatus;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: getStatusColor(status), width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  challenge.title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getStatusColor(status).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  userStatusChoices[status],
                                  style: TextStyle(color: getStatusColor(status), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            challenge.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Text('Points: ${challenge.points}'),

                          if (status == 0) ...[ // Not Started
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: ElevatedButton(onPressed: () => _startChallenge(challenge.id), child: const Text('Start'))),
                                const SizedBox(width: 12),
                                Expanded(child: OutlinedButton(onPressed: () => _stopParticipation(challenge.id), child: const Text('Stop Participation'))),
                              ],
                            ),
                          ],
                          if (status == 1) ...[ // In Progress
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: ElevatedButton(onPressed: () => _markAsCompleted(challenge.id), child: const Text('Mark as Completed'))),
                                const SizedBox(width: 12),
                                Expanded(child: OutlinedButton(onPressed: () => _stopParticipation(challenge.id), child: const Text('Stop Participation'))),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}