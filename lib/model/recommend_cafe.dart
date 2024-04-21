class RecommendCafeModel {
  final String description;

  RecommendCafeModel({
    required this.description,
  });

  factory RecommendCafeModel.fromJson(Map<String, dynamic> json) {
    return RecommendCafeModel(
      description: json['description'],
    );
  }
}
