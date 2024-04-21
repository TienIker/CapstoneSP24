import 'package:flutter/material.dart';
import 'package:sharing_cafe/model/category_model.dart';
import 'package:sharing_cafe/service/category_service.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  Future getCategories() async {
    _categories = await CategoryService().getCategories();
    notifyListeners();
  }
}
