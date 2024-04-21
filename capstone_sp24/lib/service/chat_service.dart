import 'dart:convert';
import 'dart:io';

import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/model/chat_message_model.dart';
import 'package:sharing_cafe/model/recommend_cafe.dart';
import 'package:sharing_cafe/model/schedule_model.dart';

class ChatService {
  Future<List<ChatMessageModel>> getHistory(String userId) async {
    int limit = 30;
    int offset = 0;
    var endpoint =
        "/auth/chat-history?userId=$userId&limit=$limit&offset=$offset";
    return ApiHelper().get(endpoint).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        var list = jsonList
            .map<ChatMessageModel>((e) => ChatMessageModel.fromJson(e))
            .toList();
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return list;
      } else {
        throw Exception("Failed to load chat history: ${response.statusCode}");
      }
    });
  }

  Future<List<RecommendCafeModel>> getRecommendCafe(
      String userId, String currentUserId) async {
    var endpoint =
        "/location/getRecommendCafe?userIdA=$userId&userIdB=$currentUserId";
    return ApiHelper().get(endpoint).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body);
        var list = jsonList["predictions"]
            .map<RecommendCafeModel>((e) => RecommendCafeModel.fromJson(e))
            .toList();
        return list;
      } else {
        throw Exception(
            "Failed to load recommend cafe: ${response.statusCode}");
      }
    });
  }

  Future<ScheduleModel> createSchedule(ScheduleModel scheduleModel) async {
    var endpoint = "/user/schedule";
    return ApiHelper().post(endpoint, scheduleModel.toJson()).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        var jsonMap = json.decode(response.body);
        return ScheduleModel.fromJson(jsonMap);
      } else {
        throw Exception("Failed to create schedule: ${response.statusCode}");
      }
    });
  }

  Future<List<ScheduleModel>> getSchedule(String userId) {
    var endpoint = "/auth/user/schedule/$userId";
    return ApiHelper().get(endpoint).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList
            .map<ScheduleModel>((e) => ScheduleModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    });
  }

  Future changeStatusSchedule(String scheduleId, bool isAccept) {
    var endpoint =
        "/user/schedule/status?is_accept=$isAccept&schedule_id=$scheduleId";
    return ApiHelper().put(endpoint, {}).then((response) {
      if (response.statusCode != HttpStatus.ok) {
        throw Exception(
            "Failed to change status schedule: ${response.statusCode}");
      }
    });
  }
}
