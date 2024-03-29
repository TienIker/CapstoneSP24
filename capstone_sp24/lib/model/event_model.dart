import 'package:sharing_cafe/helper/datetime_helper.dart';

class EventModel {
  final String eventId;
  final String? organizerId;
  final String title;
  final String? description;
  final DateTime timeOfEvent;
  final String? location;
  final int participantsCount;
  final bool? isAprrove;
  final String backgroundImage;
  final DateTime? createdAt;
  final DateTime? endOfEvent;
  final String? organizationName;
  final String? address;

  EventModel({
    required this.eventId,
    this.organizerId,
    required this.title,
    this.description,
    required this.timeOfEvent,
    this.location,
    required this.participantsCount,
    this.isAprrove,
    required this.backgroundImage,
    this.createdAt,
    this.endOfEvent,
    this.organizationName,
    this.address,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['event_id'],
      organizerId: json['organizer_id'],
      title: json['title'],
      description: json['description'],
      timeOfEvent: DateTimeHelper.parseToLocal(json['time_of_event']),
      location: json['location'],
      participantsCount: json['participants_count'],
      isAprrove: json['is_approve'],
      backgroundImage: json['background_img'],
      createdAt: DateTimeHelper.parseToLocal(json['created_at']),
      endOfEvent: DateTimeHelper.parseToLocal(json['end_of_event']),
      organizationName: json['name'],
      address: json['address'],
    );
  }

  factory EventModel.fromListsJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['event_id'],
      title: json['title'],
      timeOfEvent: DateTimeHelper.parseToLocal(json['time_of_event']),
      participantsCount: json['participants_count'] ?? 0,
      backgroundImage: json['background_img'],
      location: json['address'],
    );
  }
}
