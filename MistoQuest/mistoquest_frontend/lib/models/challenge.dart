class Challenge {
  final String title;
  final String description;
  final String difficulty;
  final DateTime createdDate;
  final int maxDuration;
  final int points;
  final bool isActive;

  Challenge({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.createdDate,
    required this.maxDuration,
    required this.points,
    required this.isActive,
  });

  // Factory constructor to create a Challenge from JSON
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      title: json['title'],
      description: json['description'] ?? 'There is no description yet.',
      difficulty: json['difficulty'],
      createdDate: DateTime.parse(json['created_date']),
      maxDuration: json['max_duration'],
      points: json['points'],
      isActive: json['is_active'],
    );
  }

  // Method to convert a Challenge instance to JSON
  Map<String, dynamic> toJson() {
    return {
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
  final int idUser;
  final int idChallenge;
  final DateTime userPickUpDate;
  final DateTime userCompleteDate;

  UserChallenge({
    required this.idUser,
    required this.idChallenge,
    required this.userPickUpDate,
    required this.userCompleteDate,
  });

  // Factory constructor to create a UserChallenge from JSON
  factory UserChallenge.fromJson(Map<String, dynamic> json) {
    return UserChallenge(
      idUser: json['id_user'],
      idChallenge: json['id_challenge'],
      userPickUpDate: DateTime.parse(json['user_pick_up_date']),
      userCompleteDate: DateTime.parse(json['user_complete_date']),
    );
  }

  // Method to convert a UserChallenge instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'id_challenge': idChallenge,
      'user_pick_up_date': userPickUpDate.toIso8601String(),
      'user_complete_date': userCompleteDate.toIso8601String(),
    };
  }
}
