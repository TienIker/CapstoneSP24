import 'package:sharing_cafe/helper/datetime_helper.dart';

class BlogModel {
  final String blogId;
  final String? userId;
  final String? content;
  int likesCount;
  final int commentsCount;
  final bool isApprove;
  final DateTime createdAt;
  final String image;
  final String title;
  final String ownerName;
  final String? ownerAvatar;
  final String category;
  final String? interestId;
  bool isLike;

  BlogModel({
    required this.blogId,
    required this.userId,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.isApprove,
    required this.createdAt,
    required this.image,
    required this.title,
    required this.ownerName,
    required this.category,
    required this.isLike,
    required this.interestId,
    this.ownerAvatar,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      blogId: json["blog_id"],
      userId: json["user_id"],
      content: json["content"],
      likesCount: json["likes_count"],
      commentsCount: json["comments_count"],
      isApprove: json["is_approve"],
      createdAt: DateTimeHelper.parseToLocal(json["created_at"]),
      image: json["image"],
      title: json["title"],
      ownerName: json['user_name'],
      category: json['name'],
      ownerAvatar: json['profile_avatar'],
      isLike: json['is_like'] ?? false,
      interestId: json['interest_id'],
    );
  }
}
