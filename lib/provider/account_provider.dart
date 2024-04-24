// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/service/account_service.dart';
import 'package:sharing_cafe/service/location_service.dart';

class AccountProvider extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future login(String email, String password) async {
    var pref = await _prefs;
    var token = await getToken();
    if (token == null) {
      Fluttertoast.showToast(msg: "Token is null");
    }
    var result = await AccountService().login(email, password, token);
    pref.setString("accessToken", result.token);
    pref.setString("userId", result.userId);
    pref.setString("email", result.email);
    pref.setString("userName", result.userName);
    Fluttertoast.showToast(msg: "Đăng nhập thành công");
    print(
        "${result.token}: ${result.userId}: ${result.email}: ${result.userName}");
  }

  Future logout() async {
    var pref = await _prefs;
    pref.clear();
    Fluttertoast.showToast(msg: "Đăng xuất thành công");
  }

  Future register(String userName, String email, String password) async {
    var pref = await _prefs;
    var result = await AccountService().register(userName, email, password);
    pref.setString("accessToken", result.token);
    pref.setString("userId", result.userId);
    pref.setString("email", result.email);
    pref.setString("userName", result.userName);
    pref.setString("password", result.password);
    Fluttertoast.showToast(msg: "Đăng ký thành công");
    await LocationService().updateLocation();
  }

  Future<String?> getToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print(token);
      if (token != null) {
        var pref = await _prefs;
        pref.setString('notiToken', token);
      }
    }
    return token;
  }

  Future<bool> confirmVerificationEmail(email, password) {
    return AccountService().confirmVerificationEmail(email, password);
  }

  Future completeUserProfile({
    required String? profileAvatar,
    required String? age,
    required String? addressProvince,
    required String? addressDistrict,
    required String? gender,
    required String? story,
  }) async {
    try {
      if (profileAvatar == null || profileAvatar.isEmpty) {
        throw ArgumentError('Hình ảnh là bắt buộc và không được để trống.');
      }
      if (age == null || age.isEmpty) {
        throw ArgumentError('Tuổi là bắt buộc và không được để trống.');
      }
      if (addressProvince == null ||
          addressProvince.isEmpty ||
          addressDistrict == null ||
          addressDistrict.isEmpty) {
        throw ArgumentError('Địa chỉ là bắt buộc và không được để trống.');
      }
      if (gender == null || gender.isEmpty) {
        throw ArgumentError('Giới tính là bắt buộc và không được để trống.');
      }

      return await AccountService().completeUserProfile(
        profileAvatar: profileAvatar,
        age: age,
        address: "$addressDistrict, $addressProvince",
        gender: gender,
        story: story,
      );
    } catch (e) {
      if (e is ArgumentError) {
        ErrorHelper.showError(message: e.message);
      } else {
        ErrorHelper.showError(message: e.toString());
      }
    }
  }
}
