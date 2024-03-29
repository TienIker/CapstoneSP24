import 'package:flutter/material.dart';
import 'package:sharing_cafe/model/interest_model.dart';
import 'package:sharing_cafe/service/interest_service.dart';

class InterestProvider extends ChangeNotifier {
  // private variables
  List<InterestModel> _listInterests = [];

  // public
  List<InterestModel> get listInterests => _listInterests;

  Future getListInterests() async {
    _listInterests = await InterestService().getListInterests();
    notifyListeners();
  }
}
