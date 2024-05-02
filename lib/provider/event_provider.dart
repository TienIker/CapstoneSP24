import 'package:flutter/material.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/event_model.dart';
import 'package:sharing_cafe/service/event_service.dart';

class EventProvider extends ChangeNotifier {
  // private variables
  List<EventModel> _newEvents = [];
  List<EventModel> _suggestEvents = [];
  List<EventModel> _myEvents = [];
  EventModel? _eventDetails;
  final List<String> _searchHistory = [];
  List<EventModel> _searchEvents = [];
  // public
  List<EventModel> get newEvents => _newEvents;
  List<EventModel> get suggestEvents => _suggestEvents;
  List<EventModel> get myEvents => _myEvents;
  EventModel get eventDetails => _eventDetails!;
  List<String> get searchHistory => _searchHistory;
  List<EventModel> get searchEvents => _searchEvents;

  Future getNewEvents() async {
    _newEvents = await EventService().getNewEvents();
    notifyListeners();
  }

  Future getSuggestEvents() async {
    _suggestEvents = await EventService().getSuggestEvents();
    notifyListeners();
  }

  Future getEventDetails(String id) async {
    _eventDetails = await EventService().getEventDetails(id);
    notifyListeners();
  }

  Future getMyEvents() async {
    _myEvents = await EventService().getMyEvents();
    notifyListeners();
  }

  void removeFromSearchHistory(String query) {
    _searchHistory.remove(query);
    notifyListeners();
  }

  void removeAllSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  Future search(String searchString) async {
    if (searchString == "") {
      _searchEvents.clear();
      notifyListeners();
      return;
    }
    _searchEvents = await EventService().getEvents(searchString);
    notifyListeners();
  }

  disposeSearchEvents() {
    _searchEvents.clear();
    notifyListeners();
  }

  void insertSearchHistry(String value) {
    if (value.isNotEmpty) {
      _searchHistory.add(value);
      notifyListeners();
    }
  }

  Future createOrUpdateEvent({
    required String title,
    required String interestId,
    required String description,
    required String timeOfEvent,
    required String location,
    required String backgroundImage,
    String? eventId,
    required String endOfEvent,
    required String address,
  }) async {
    try {
      // Validate Title
      if (title.isEmpty) {
        throw ArgumentError('Tiêu đề là bắt buộc và không được để trống.');
      }

      // Validate Interest ID
      if (interestId.isEmpty) {
        throw ArgumentError('Chủ đề là bắt buộc và không được để trống.');
      }

      // Validate Description
      if (description.isEmpty) {
        throw ArgumentError('Mô tả là bắt buộc và không được để trống.');
      }

      // Validate Time of Event
      if (timeOfEvent.isEmpty) {
        throw ArgumentError(
            'Thời gian sự kiện là bắt buộc và không được để trống.');
      }

      // Validate Location
      if (location.isEmpty) {
        throw ArgumentError(
            'Địa điểm tổ chức là bắt buộc và không được để trống.');
      }

      // Validate Background Image
      if (backgroundImage.isEmpty) {
        throw ArgumentError('Ảnh bìa là bắt buộc và không được để trống.');
      }

      if (address.isEmpty) {
        throw ArgumentError('Địa chỉ là bắt buộc và không được để trống.');
      }
      if (eventId != null) {
        return await EventService().updateEvent(
          eventId: eventId,
          title: title,
          interestId: interestId,
          description: description,
          timeOfEvent: timeOfEvent,
          location: location,
          backgroundImage: backgroundImage,
          endOfEvent: endOfEvent,
          address: address,
        );
      }

      return await EventService().createEvent(
        title: title,
        interestId: interestId,
        description: description,
        timeOfEvent: timeOfEvent,
        location: location,
        backgroundImage: backgroundImage,
        endOfEvent: endOfEvent,
        address: address,
      );
    } catch (e) {
      if (e is ArgumentError) {
        ErrorHelper.showError(message: e.message);
      } else {
        ErrorHelper.showError(message: e.toString());
      }
    }
  }

  Future<bool> deleteEvent(String eventId) {
    return EventService().deleteEvent(eventId);
  }
}
