class ProfileModel {
  final String userId;
  final String image;
  final String name;
  final String phone;
  // final String address;
  final String? description;
  final String gender;
  final String age;
  final String purpose;
  final String interest;
  final String problem;
  final String unlikeTopic;
  final String favoriteDrink;
  final String freeTime;

  ProfileModel({
    required this.userId,
    required this.image,
    required this.name,
    required this.phone,
    // required this.address,
    this.description,
    required this.gender,
    required this.age,
    required this.purpose,
    required this.interest,
    required this.problem,
    required this.unlikeTopic,
    required this.favoriteDrink,
    required this.freeTime,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json["user_id"],
      image: json["profile_avatar"],
      name: json["user_name"],
      phone: json["phone"],
      // address: json["address"],
      description: json["story"],
      gender: json["gender"],
      age: json["age"],
      purpose: json["purpose"],
      interest: json["interest_name"],
      problem: json["personal_problem"],
      unlikeTopic: json["unlike_topic"],
      favoriteDrink: json["favorite_drink"],
      freeTime: json["free_time"],
    );
  }
}
