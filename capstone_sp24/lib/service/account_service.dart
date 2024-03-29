// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/account_model.dart';

class AccountService {
  Future<AccountModel> login(String email, String password) async {
    try {
      var endpoint = "/user/login";
      var data = {"email": email, "password": password};
      var response = await ApiHelper().post(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        var json = jsonDecode(response.body);
        return AccountModel.fromJson(json);
      } else {
        throw Exception("Unauthorized: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      ErrorHelper.showError(message: "Không thể đăng nhập!");
      rethrow;
    }
  }

  Future<AccountModel> register(
      String userName, String email, String password) async {
    try {
      var endpoint = "/user/register";
      var data = {"user_name": userName, "email": email, "password": password};
      var response = await ApiHelper().post(endpoint, data);
      if (response.statusCode == HttpStatus.ok) {
        var json = jsonDecode(response.body);
        return AccountModel.fromJson(json);
      } else if (response.statusCode == HttpStatus.conflict) {
        // Thêm điều kiện xử lý trường hợp email đã được đăng ký
        throw Exception("Email đã được đăng ký");
      } else {
        throw Exception("Unauthorized: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      if (e.toString().contains('Email đã được đăng ký')) {
        ErrorHelper.showError(message: "Email đã được đăng ký");
      } else {
        ErrorHelper.showError(message: "Không thể đăng ký!");
      }
      rethrow;
    }
  }
}
