class InterestModel {
  final String interestId;
  final String name;
  final String imageUrl;
  final String numOfBlog;

  InterestModel({
    required this.interestId,
    required this.name,
    required this.imageUrl,
    this.numOfBlog = "0",
  });

  factory InterestModel.fromListsJson(Map<String, dynamic> json) {
    return InterestModel(
      interestId: json["interest_id"],
      name: json["name"],
      imageUrl: json["image"] == null || json["image"] == ""
          ? "https://picsum.photos/id/200/200/300"
          : json["image"],
      numOfBlog: json["num_of_blog"] ?? "0",
    );
  }
}
