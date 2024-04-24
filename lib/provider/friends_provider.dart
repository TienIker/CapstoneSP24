import 'package:flutter/material.dart';
import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/matched_model.dart';
import 'package:sharing_cafe/service/match_service.dart';

class FriendsProvider extends ChangeNotifier {
  List<MatchedModel> _friends = [];
  List<MatchedModel> get friends => _friends;
  Future getListFriends({bool pending = false}) async {
    _friends = await MatchService().getListFriends(pending: pending);
    notifyListeners();
  }

  Future likeOrUnlike(String userId, MatchStatus status) async {
    try {
      var result = await MatchService().updateMatchStatus(userId, status);
      if (result == true) {
        _friends.removeWhere((element) => element.userId == userId);
        notifyListeners();
      }
    } on Exception catch (e) {
      ErrorHelper.showError(message: e.toString());
    }
  }
}
