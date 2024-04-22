// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/user_profile_model.dart';

class UserProfileService {
  Future<UserProfileModel?> getUserProfile() async {
    try {
      var response = await ApiHelper().get('/auth/user/profile');
      if (response.statusCode == HttpStatus.ok) {
        var res = UserProfileModel.fromJson(json.decode(response.body));
        return res;
      } else {
        ErrorHelper.showError(
            message: "Lỗi ${response.statusCode}: Không thể lấy thông tin");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return null;
  }

  Future<bool> updateUserProfile({
    required String profileAvatar,
    required String userName,
    required String age,
    required String? address,
    required String gender,
    required String? story,
    required String? purpose,
    required String? favoriteLocation,
  }) async {
    try {
      var endpoint = "/auth/user/profile";
      var data = {
        "profile_avatar": profileAvatar,
        "user_name": userName,
        "age": age,
        "address": address,
        "gender": gender,
        "story": story,
        "purpose": purpose,
        "favorite_location": favoriteLocation,
      };
      var response = await ApiHelper().put(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể cập nhật thông tin");
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateInterest({
    required List<String> interestId,
  }) async {
    try {
      var endpoint = "/auth/user/update-interests";
      var data = interestId.map((e) => {"interest_id": e}).toList();
      var response = await ApiHelper().putList(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể cập nhật");
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateProblem({
    required List<String> problem,
  }) async {
    try {
      var endpoint = "/auth/user/update-personal-problem";
      var data = problem.map((e) => {"problem": e}).toList();
      var response = await ApiHelper().putList(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể cập nhật");
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateUnlikeTopic({
    required List<String> unlikeTopic,
  }) async {
    try {
      var endpoint = "/auth/user/update-unlike-topic";
      var data = unlikeTopic.map((e) => {"topic": e}).toList();
      var response = await ApiHelper().putList(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể cập nhật");
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateFavoriteDrink({
    required List<String> favoriteDrink,
  }) async {
    try {
      var endpoint = "/auth/user/update-favorite-drink";
      var data = favoriteDrink.map((e) => {"favorite_drink": e}).toList();
      var response = await ApiHelper().putList(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể cập nhật");
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateFreetime({
    required List<String> freeTime,
  }) async {
    try {
      var endpoint = "/auth/user/update-free-time";
      var data = freeTime.map((e) => {"free_time": e}).toList();
      var response = await ApiHelper().putList(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể cập nhật");
    } catch (e) {
      print(e);
    }
    return false;
  }
}
