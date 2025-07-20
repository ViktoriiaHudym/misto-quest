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
  final PageController _pageController = PageController(viewportFraction: 0.8);
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
      // Featured Challenges
        content = FutureBuilder<List<Challenge>>(
          future: _challengesFuture,
          builder: _buildChallengesSlider,
        );
        break;
      case 1:
      // Participating Challenges
        content = const UserParticipationScreen();
        break;
      case 2:
      // Account & Settings
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

    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Квести доступні у твоєму місті',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: challenges.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return ChallengeSliderCard(challenge: challenge);
            },
          ),
        ),
        const SizedBox(height: 12),
        _IndicatorRow(
          count: challenges.length,
          currentIndex: _currentIndex,
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
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
