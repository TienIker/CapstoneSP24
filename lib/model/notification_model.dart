import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';

class NotificationModel {
  final String id;
  // final String title;
  final String content;
  final DateTime createdAt;
  final NotificationStatus status;

  NotificationModel(
      {required this.id,
      // required this.title,
      required this.content,
      required this.createdAt,
      required this.status});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['notification_id'],
      // title: json['title'],
      content: json['content'],
      createdAt: DateTimeHelper.parseToLocal(json['created_at']),
      status: NotificationStatus.fromString(json['notification_status']),
    );
  }
}
