import 'package:flutter/material.dart';
// import 'package:mistoquest_frontend/models/challenge.dart';

import '../models/challenge.dart';

class ChallengeCard extends StatelessWidget {
  final VoidCallback onTap;
  final Challenge challenge;

  const ChallengeCard({super.key, required this.onTap, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color(0XFF5B595A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 455,
        width: 280,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0XFF5B595A),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 190,
                width: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/Challenge-PNG-File.png'),  // Use placeholder or image for the challenge
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              challenge.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              challenge.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: const Size(double.maxFinite, 44),
              ),
              child: const Text(
                "JOIN CHALLENGE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
