class EventParticipantModel {
  String? userId;
  String? userName;
  String? profileAvatar;

  EventParticipantModel({
    required this.userId,
    required this.userName,
    required this.profileAvatar,
  });

  factory EventParticipantModel.fromJson(Map<String, dynamic> json) =>
      EventParticipantModel(
        userId: json["user_id"],
        userName: json["user_name"],
        profileAvatar: json["profile_avatar"],
      );
}
