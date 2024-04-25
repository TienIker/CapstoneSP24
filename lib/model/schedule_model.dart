import 'package:sharing_cafe/helper/datetime_helper.dart';

class ScheduleModel {
  ScheduleModel(
      {required this.createdAt,
      required this.scheduleId,
      required this.content,
      required this.location,
      required this.date,
      required this.senderId,
      required this.receiverId,
      required this.isAccept,
      this.receiverName,
      this.receiverAvt,
      this.senderName,
      this.senderAvt,
      this.rating});

  final DateTime createdAt;
  final String scheduleId;
  final String content;
  final String location;
  final DateTime date;
  final String senderId;
  final String? senderName;
  final String? senderAvt;
  final String receiverId;
  final String? receiverName;
  final String? receiverAvt;
  bool? isAccept;
  final List<Rating>? rating;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        createdAt: DateTimeHelper.parseToLocal(json["created_at"]),
        scheduleId: json["schedule_id"],
        content: json["content"],
        location: json["location"],
        date: DateTimeHelper.parseToLocal(json["schedule_time"]),
        senderId: json["sender_id"],
        receiverName: json["receiver"],
        receiverAvt: json["receiver_avatar"],
        senderName: json["sender"],
        senderAvt: json["sender_avatar"],
        receiverId: json["receiver_id"],
        isAccept: json["is_accept"],
        rating: json["rating"] != null
            ? List<Rating>.from(json["rating"].map((x) => Rating.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "content": content,
        "location": location,
        "date": date.toIso8601String(),
      };
}

class Rating {
  String? rating;
  String? content;
  String? userId;
  String? ratingId;
  String? userName;

  Rating({
    required this.rating,
    required this.content,
    required this.userId,
    required this.ratingId,
    required this.userName,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rating: json["rating"],
        content: json["content"],
        userId: json["user_id"],
        ratingId: json["rating_id"],
        userName: json["user_name"],
      );
}
