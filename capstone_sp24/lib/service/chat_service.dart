import 'dart:convert';
import 'dart:io';

import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/model/chat_message_model.dart';

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
}
