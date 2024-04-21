import 'package:flutter/material.dart';
import 'package:sharing_cafe/model/interest_model.dart';
import 'package:sharing_cafe/service/interest_service.dart';

class InterestProvider extends ChangeNotifier {
  // private variables
  List<InterestModel> _listInterests = [];
  List<InterestModel> _listInterestsParent = [];

  // public
  List<InterestModel> get listInterests => _listInterests;
  List<InterestModel> get listInterestsParent => _listInterestsParent;

  Future getListInterests() async {
    _listInterests = await InterestService().getListInterests();
    notifyListeners();
  }

  Future getListInterestsParent() async {
    _listInterestsParent = await InterestService().getListInterestsParent();
    notifyListeners();
  }
}
