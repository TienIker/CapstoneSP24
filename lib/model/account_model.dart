class AccountModel {
  final String userId;
  final String userName;
  final String token;
  final String email;
  final String password;

  AccountModel(
      {required this.userId,
      required this.userName,
      required this.token,
      required this.email,
      required this.password});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      userId: json["user_id"],
      userName: json["user_name"],
      token: json["accessToken"],
      email: json["email"],
      password: json["password"],
    );
  }
}
