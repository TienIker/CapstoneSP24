class InterestModel {
  final String interestId;
  final String name;
  final String imageUrl;
  final String numOfBlog;

  InterestModel({
    required this.interestId,
    required this.name,
    required this.imageUrl,
    required this.numOfBlog,
  });

  factory InterestModel.fromListsJson(Map<String, dynamic> json) {
    return InterestModel(
      interestId: json["interest_id"],
      name: json["name"],
      imageUrl: json["image"] == null || json["image"] == ""
          ? "https://picsum.photos/id/200/200/300"
          : json["image"],
      numOfBlog: json["blog_count"] ?? "0",
    );
  }
}
