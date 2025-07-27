import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/challenge.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'user_participation_screen.dart';
import '../widgets/challenge_slider_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Challenge>> _challengesFuture;
  // Adjust viewportFraction to control how much of the next/previous cards are visible
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _challengesFuture = ApiService().fetchChallenges();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedNavIndex) {
      case 0:
        content = FutureBuilder<List<Challenge>>(
          future: _challengesFuture,
          builder: _buildChallengesSlider,
        );
        break;
      case 1:
        content = const UserParticipationScreen();
        break;
      case 2:
        content = const Center(
          child: Text('Account & Settings screen (to be implemented)'),
        );
        break;
      default:
        content = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MistoQuest'),
        centerTitle: true,
      ),
      body: content,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
    );
  }

  Widget _buildChallengesSlider(BuildContext context, AsyncSnapshot<List<Challenge>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    final challenges = snapshot.data;
    if (challenges == null || challenges.isEmpty) {
      return const Center(child: Text('No challenges available.'));
    }

    // Use Expanded to make the PageView take up available vertical space
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Квести доступні у твоєму місті',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: challenges.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return ChallengeSliderCard(
                challenge: challenge,
                onAccept: () async {
                  final api = ApiService();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Accepting challenge...')));
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red));
                  }
                },
              );
            },
          ),
        ),
        // The page indicator can be placed at the bottom
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: _IndicatorRow(
            count: challenges.length,
            currentIndex: _currentIndex,
          ),
        ),
      ],
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  final int count;
  final int currentIndex;
  const _IndicatorRow({Key? key, required this.count, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}