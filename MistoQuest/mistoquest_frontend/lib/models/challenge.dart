class Challenge {
  final int id;
  final String title;
  final String description;
  final String difficulty;
  final DateTime createdDate;
  final int maxDuration;
  final int points;
  final bool isActive;
  final String? imageUrl;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.createdDate,
    required this.maxDuration,
    required this.points,
    required this.isActive,
    this.imageUrl,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? 'There is no description yet.',
      difficulty: json['difficulty'],
      createdDate: DateTime.parse(json['created_date']),
      maxDuration: json['max_duration'],
      points: json['points'],
      isActive: json['is_active'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'created_date': createdDate.toIso8601String(),
      'max_duration': maxDuration,
      'points': points,
      'is_active': isActive,
    };
  }
}

class UserChallenge {
  // We do not need idUser and idChallenge as separate fields
  // because they are inside the nested Challenge object.
  final Challenge challenge;
  final DateTime userPickUpDate;
  final DateTime? userCompleteDate;
  final int userCompleteStatus;

  UserChallenge({
    required this.challenge,
    required this.userPickUpDate,
    required this.userCompleteDate,
    required this.userCompleteStatus,
  });

  factory UserChallenge.fromJson(Map<String, dynamic> json) {
    return UserChallenge(
      challenge: Challenge.fromJson(json['id_challenge']),
      userPickUpDate: DateTime.parse(json['user_pick_up_date']),
      userCompleteDate: json['user_complete_date'] != null && json['user_complete_date'] != ''
          ? DateTime.parse(json['user_complete_date'])
          : null,
      userCompleteStatus: json['user_complete_status'],
    );
  }
}