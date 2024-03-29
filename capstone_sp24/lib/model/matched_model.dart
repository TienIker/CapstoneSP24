class MatchedModel {
  final String userId;
  final String userName;
  final String profileAvatar;
  final String bio;
  final bool isAvailable;
  final String userMatchStatus;

  MatchedModel({
    required this.userId,
    required this.userName,
    required this.profileAvatar,
    this.bio = '',
    required this.isAvailable,
    required this.userMatchStatus,
  });

  factory MatchedModel.fromJson(Map<String, dynamic> json) {
    return MatchedModel(
      userId: json['user_id'],
      userName: json['user_name'],
      profileAvatar: json['profile_avatar'],
      bio: json['Bio'] ?? '',
      isAvailable: json['is_available'],
      userMatchStatus: json['user_match_status'],
    );
  }
}
