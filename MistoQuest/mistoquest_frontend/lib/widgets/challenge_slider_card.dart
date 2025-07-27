import 'package:flutter/material.dart';
import '../models/challenge.dart';

class ChallengeSliderCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onAccept;

  const ChallengeSliderCard({
    super.key,
    required this.challenge,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (challenge.imageUrl != null)
            // If an image URL exists, load it from the network
              Image.network(
                challenge.imageUrl!,
                fit: BoxFit.cover,
                // Show a loading indicator
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                // Show an error icon if it fails to load
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
                },
              )
            else
            // Otherwise, show the placeholder asset
              Image.asset(
                'assets/test2.jpg',
                fit: BoxFit.cover,
              ),

            // Gradient Overlay for Text Readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // Text and Button Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Align content to the bottom
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    challenge.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      shadows: const [Shadow(blurRadius: 8, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Points: ${challenge.points}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Accept Button
                      ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}