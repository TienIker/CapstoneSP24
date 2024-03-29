// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> getCategories() async {
    try {
      var response = await ApiHelper().get('/interest');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList
            .map<CategoryModel>((e) => CategoryModel.fromJson(e))
            .toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách chủ đề");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }
}
