import 'dart:convert';
import 'dart:io';

import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/model/matched_model.dart';
import 'package:sharing_cafe/model/profile_model.dart';

class MatchService {
  Future<List<ProfileModel>> getListProfiles(int limit, int offset) async {
    var endpoint = "/auth/matches-interest?limit=$limit&offset=$offset";
    var response = await ApiHelper().get(endpoint);
    if (response.statusCode == HttpStatus.ok) {
      var result = json.decode(response.body);
      var jsonList = result["data"] as List;
      return jsonList
          .map<ProfileModel>((e) => ProfileModel.fromJson(e))
          .toList();
    }
    return List.empty();
  }

  Future<bool> updateMatchStatus(String userId, MatchStatus status) async {
    var endpoint = "/auth/matching-status";
    var payload = {
      "user_id": userId,
      "status": status.label,
    };
    var response = await ApiHelper().put(endpoint, payload);
    if (response.statusCode == HttpStatus.ok) {
      json.decode(response.body);
      return true;
    } else {
      throw Exception("Action error: ${response.statusCode}");
    }
  }

  Future<List<MatchedModel>> getListFriends() async {
    var endpoint = "/auth/matched";
    var response = await ApiHelper().get(endpoint);
    if (response.statusCode == HttpStatus.ok) {
      var result = json.decode(response.body);
      var jsonList = result as List;
      return jsonList
          .map<MatchedModel>((e) => MatchedModel.fromJson(e))
          .toList();
    }
    return List.empty();
  }
}
