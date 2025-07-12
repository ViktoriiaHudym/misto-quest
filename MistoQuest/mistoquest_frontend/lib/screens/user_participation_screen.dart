import 'package:flutter/material.dart';
import 'package:mistoquest_frontend/services/api_service.dart';
import 'package:mistoquest_frontend/models/challenge.dart';


const USER_STATUS_CHOICES = [
  'Not Started',
  'In Progress',
  'Completed',
  'Failed',
  'Terminated',
];

Color getStatusColor(int status) {
  switch (status) {
    case 1:
      return Colors.yellow.shade700;
    case 2:
      return Colors.green.shade400;
    case 3:
    case 4:
      return Colors.grey.shade500;
    default:
      return Colors.grey.shade300;
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
  final int _userId = 1; // Hardcoded user ID for now

  @override
  void initState() {
    super.initState();
    _userChallengesFuture = _apiService.fetchUserChallenges(userId: _userId);
  }

  List<UserChallenge> _filterChallenges(List<UserChallenge> challenges) {
    if (_selectedStatusFilter == null) {
      return challenges;
    }
    return challenges.where((challenge) => 
      challenge.userCompleteStatus == _selectedStatusFilter
    ).toList();
  }

  Future<void> _markAsCompleted(int challengeId) async {
    try {
      await _apiService.completeChallenge(_userId, challengeId);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Challenge marked as completed!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh the challenges list
      setState(() {
        _userChallengesFuture = _apiService.fetchUserChallenges(userId: _userId);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete challenge: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              ...List.generate(USER_STATUS_CHOICES.length, (index) {
                return ListTile(
                  title: Text(USER_STATUS_CHOICES[index]),
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
      body: FutureBuilder<List<UserChallenge>>(
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No challenges with status "${_selectedStatusFilter != null ? USER_STATUS_CHOICES[_selectedStatusFilter!] : 'All'}"',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStatusFilter = null;
                        });
                      },
                      child: const Text('Clear Filter'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: userChallenges.length,
              itemBuilder: (context, index) {
                final userChallenge = userChallenges[index];
                return FutureBuilder<Challenge>(
                  future: _apiService.fetchChallengeById(userChallenge.idChallenge),
                  builder: (context, challengeSnapshot) {
                    if (challengeSnapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (challengeSnapshot.hasError) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text('Error loading challenge'),
                          subtitle: Text('ID: ${userChallenge.idChallenge}'),
                        ),
                      );
                    } else if (!challengeSnapshot.hasData) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text('Challenge not found'),
                          subtitle: Text('ID: ${userChallenge.idChallenge}'),
                        ),
                      );
                    } else {
                      final challenge = challengeSnapshot.data!;
                      final status = userChallenge.userCompleteStatus;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                decoration: BoxDecoration(
                                  color: getStatusColor(status),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              challenge.title,
                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: getStatusColor(status).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              USER_STATUS_CHOICES[status],
                                              style: TextStyle(
                                                color: getStatusColor(status),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        challenge.description,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Text('Points: ${challenge.points}'),
                                      if (status == 1) ...[
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () => _markAsCompleted(userChallenge.idChallenge),
                                                child: const Text('Mark as Completed'),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  // TODO: Implement stop participation
                                                },
                                                child: const Text('Stop Participation'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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


