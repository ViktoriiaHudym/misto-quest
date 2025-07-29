import 'package:flutter/material.dart';
import '../models/challenge.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onAccept; 

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(challenge.description, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Points: ${challenge.points}'),
                // This is the button that was missing from your UI
                ElevatedButton(
                  onPressed: onAccept, // The button now uses the function
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}