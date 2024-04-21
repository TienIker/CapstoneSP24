class CategoryModel {
  final String categoryId;
  final String title;

  CategoryModel({required this.categoryId, required this.title});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['interest_id'],
      title: json['name'],
    );
  }
}
