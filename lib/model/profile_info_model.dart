class ProfileInfoModel {
  String userId;
  String userName;
  String profileAvatar;
  String? story;
  String gender;
  String age;
  String? purpose;
  String? favoriteLocation;
  String address;
  String? distance;
  List<Interest> interest;
  List<Problem> problem;
  List<UnlikeTopic> unlikeTopic;
  List<FavoriteDrink> favoriteDrink;
  List<FreeTime> freeTime;

  ProfileInfoModel({
    required this.userId,
    required this.userName,
    required this.profileAvatar,
    this.story,
    this.distance,
    required this.gender,
    required this.age,
    required this.purpose,
    required this.favoriteLocation,
    required this.address,
    required this.interest,
    required this.problem,
    required this.unlikeTopic,
    required this.favoriteDrink,
    required this.freeTime,
  });

  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfileInfoModel(
      userId: json['user_id'],
      userName: json['user_name'],
      profileAvatar: json['profile_avatar'],
      story: json['story'],
      gender: json['gender'],
      age: json['age'],
      distance: json['distance'],
      purpose: json['purpose'],
      favoriteLocation: json['favorite_location'],
      address: json['address'],
      interest: List<Interest>.from(
          json['interest'].map((x) => Interest.fromJson(x))),
      problem:
          List<Problem>.from(json['problem'].map((x) => Problem.fromJson(x))),
      unlikeTopic: List<UnlikeTopic>.from(
          json['unlike_topic'].map((x) => UnlikeTopic.fromJson(x))),
      favoriteDrink: List<FavoriteDrink>.from(
          json['favorite_drink'].map((x) => FavoriteDrink.fromJson(x))),
      freeTime: List<FreeTime>.from(
          json['free_time'].map((x) => FreeTime.fromJson(x))),
    );
  }
}

class Interest {
  String interestId;
  String interestName;

  Interest({required this.interestId, required this.interestName});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      interestId: json['interest_id'],
      interestName: json['interest_name'],
    );
  }
}

class Problem {
  String personalProblemId;
  String problem;

  Problem({required this.personalProblemId, required this.problem});

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      personalProblemId: json['personal_problem_id'],
      problem: json['problem'],
    );
  }
}

class UnlikeTopic {
  String unlikeTopicId;
  String unlikeTopic;

  UnlikeTopic({required this.unlikeTopicId, required this.unlikeTopic});

  factory UnlikeTopic.fromJson(Map<String, dynamic> json) {
    return UnlikeTopic(
      unlikeTopicId: json['unlike_topic_id'],
      unlikeTopic: json['topic'],
    );
  }
}

class FavoriteDrink {
  String favoriteDrinkId;
  String favoriteDrink;

  FavoriteDrink({required this.favoriteDrinkId, required this.favoriteDrink});

  factory FavoriteDrink.fromJson(Map<String, dynamic> json) {
    return FavoriteDrink(
      favoriteDrinkId: json['favorite_drink_id'],
      favoriteDrink: json['favorite_drink'],
    );
  }
}

class FreeTime {
  String freeTimeId;
  String freeTime;

  FreeTime({required this.freeTimeId, required this.freeTime});

  factory FreeTime.fromJson(Map<String, dynamic> json) {
    return FreeTime(
      freeTimeId: json['free_time_id'],
      freeTime: json['free_time'],
    );
  }
}
