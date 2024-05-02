// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/event_model.dart';
import 'package:sharing_cafe/model/event_participant.dart';

class EventService {
  Future<List<EventModel>> getEvents(String? search) async {
    try {
      var response = await ApiHelper().get('/event?title=$search');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList
            .map<EventModel>((e) => EventModel.fromListsJson(e))
            .toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách sự kiện");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  Future<List<EventModel>> getSuggestEvents() async {
    try {
      var response = await ApiHelper().get('/event/popular/events');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList
            .map<EventModel>((e) => EventModel.fromListsJson(e))
            .toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách sự kiện");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  Future<List<EventModel>> getNewEvents() async {
    try {
      var response = await ApiHelper().get('/event/new/events');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList
            .map<EventModel>((e) => EventModel.fromListsJson(e))
            .toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách sự kiện");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  Future<EventModel?> getEventDetails(String eventId) async {
    try {
      var response = await ApiHelper().get('/event/$eventId');
      if (response.statusCode == HttpStatus.ok) {
        return EventModel.fromJson(json.decode(response.body)[0]);
      } else {
        ErrorHelper.showError(
            message: "Lỗi ${response.statusCode}: Không thể lấy sự kiện");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return null;
  }

  Future<List<EventModel>> getMyEvents() async {
    try {
      // var userId = await SharedPrefHelper.getUserId();
      var response = await ApiHelper().get('/auth/user/my-event');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        var res = jsonList
            .map<EventModel>((e) => EventModel.fromListsJson(e))
            .toList();
        res.sort((a, b) => a.timeOfEvent.compareTo(b.timeOfEvent));
        return res;
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách sự kiện");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  Future<bool> createEvent({
    required String title,
    required String interestId,
    required String description,
    required String timeOfEvent,
    required String location,
    required String backgroundImage,
    required String endOfEvent,
    required String address,
  }) async {
    try {
      var endpoint = "/event";
      var userId = await SharedPrefHelper.getUserId();
      var data = {
        "organizer_id": userId,
        "interest_id": interestId,
        "title": title,
        "description": description,
        "time_of_event": timeOfEvent,
        "location": location,
        "background_img": backgroundImage,
        "end_of_event": endOfEvent,
        "address": address,
      };
      var response = await ApiHelper().post(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể tạo sự kiện");
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future updateEvent({
    required String eventId,
    required String title,
    required String interestId,
    required String description,
    required String timeOfEvent,
    required String location,
    required String backgroundImage,
    required String endOfEvent,
    required String address,
  }) async {
    try {
      var endpoint = "/event/$eventId";
      var userId = await SharedPrefHelper.getUserId();
      var data = {
        "organizer_id": userId,
        "interest_id": interestId,
        "title": title,
        "description": description,
        "time_of_event": timeOfEvent,
        "location": location,
        "background_img": backgroundImage,
        "end_of_event": endOfEvent,
        "address": address,
      };
      var response = await ApiHelper().put(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể cập nhật sự kiện");
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future joinEvent(String eventId) async {
    try {
      var endpoint = "/auth/user/event/join-event?event_id=$eventId";
      var response = await ApiHelper().post(endpoint, {});
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể tham gia sự kiện");
    } catch (e) {
      print(e);
    }
    return false;
  }

  // get list event-participants
  Future<List<EventParticipantModel>> getEventParticipants(
      String eventId) async {
    try {
      var endpoint = "/auth/user/event/event-participants?event_id=$eventId";
      var response = await ApiHelper().get(endpoint);
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList
            .map<EventParticipantModel>(
                (e) => EventParticipantModel.fromJson(e))
            .toList();
      }
      ErrorHelper.showError(
          message:
              "Lỗi ${response.statusCode}: Không thể lấy danh sách người tham gia sự kiện");
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future leaveEvent(String eventId) async {
    try {
      var endpoint = "/auth/user/event/leave-event?event_id=$eventId";
      var response = await ApiHelper().put(endpoint, {});
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể rời khỏi sự kiện");
    } catch (e) {
      print(e);
    }
    return false;
  }

  // report event
  Future reportEvent(
      {required String reporterId,
      required String eventId,
      required String content}) async {
    var data = {
      "reporter_id": reporterId,
      "event_id": eventId,
      "content": content
    };
    var response = await ApiHelper().post('/user/events/report', data);
    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(msg: "Báo cáo event thành công");
      return true;
    } else {
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể báo cáo event");
    }
    return false;
  }

  //delete event
  Future<bool> deleteEvent(String eventId) async {
    try {
      var response = await ApiHelper().delete('/event/$eventId');
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể xóa sự kiện");
    } catch (e) {
      print(e);
    }
    return false;
  }
}
