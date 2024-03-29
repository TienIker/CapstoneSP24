class InterestModel {
  final String interestId;
  final String name;

  InterestModel({
    required this.interestId,
    required this.name,
  });

  factory InterestModel.fromListsJson(Map<String, dynamic> json) {
    return InterestModel(
      interestId: json["interest_id"],
      name: json["name"],
    );
  }
}
