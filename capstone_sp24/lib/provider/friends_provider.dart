import 'package:flutter/material.dart';
import 'package:sharing_cafe/model/matched_model.dart';
import 'package:sharing_cafe/service/match_service.dart';

class FriendsProvider extends ChangeNotifier {
  List<MatchedModel> _friends = [];

  List<MatchedModel> get friends => _friends;

  Future getListFriends() async {
    _friends = await MatchService().getListFriends();
    notifyListeners();
  }
}
