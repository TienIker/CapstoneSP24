import 'package:sharing_cafe/helper/datetime_helper.dart';

class ChatMessageModel {
  final String messageId;
  final String senderId;
  final String senderAvt;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String receiverAvt;
  final String messageContent;
  final DateTime createdAt;
  bool? messageType;
  final Appointment? appointment;
  final bool isAppointment;

  ChatMessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.messageContent,
    required this.createdAt,
    required this.senderAvt,
    required this.senderName,
    required this.receiverName,
    required this.receiverAvt,
    this.appointment,
    this.messageType,
    this.isAppointment = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      messageId: json['message_id'],
      senderId: json['sender_id'],
      senderAvt: json['sender_avatar'],
      senderName: json['sender_name'],
      receiverId: json['receiver_id'],
      receiverName: json['receiver_name'],
      receiverAvt: json['receiver_avatar'],
      messageContent: json['content'],
      createdAt: DateTimeHelper.parseToLocal(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': senderId,
      'to': receiverId,
      'message': messageContent,
      'timestamp': createdAt.toIso8601String(),
    };
  }
}

class Appointment {
  String? id;
  String title;
  String location;
  DateTime dateTime;
  bool? isApproved;

  Appointment({
    this.id,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.isApproved,
  });
}
