import 'dart:math';

class ProfileModel {
  final String userId;
  final String image;
  final String name;
  final String? description;
  final int age;

  ProfileModel({
    required this.userId,
    required this.image,
    required this.name,
    this.description,
    required this.age,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json["user_id"],
      image: json["profile_avatar"],
      name: json["user_name"],
      age: Random().nextInt(30) + 15,
      description: json["Bio"],
    );
  }
}
