// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/profile_info_model.dart';
import 'package:sharing_cafe/model/profile_model.dart';
import 'package:sharing_cafe/service/match_service.dart';

class MatchProvider extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  ProfileModel? _currentProfile;
  ProfileInfoModel? _info;
  final int _limit = 5;
  final int _offset = 0;

  List<ProfileModel> get profiles => _profiles;
  ProfileModel? get currentProfile => _currentProfile;
  ProfileInfoModel? get info => _info;

  Future initListProfiles() async {
    _profiles = await MatchService().getListProfiles(_limit, _offset);
    _currentProfile = _profiles.firstOrNull;
    notifyListeners();
  }

  Future likeOrUnlike(MatchStatus status) async {
    try {
      var userId = _currentProfile!.userId;
      var result = await MatchService().updateMatchStatus(userId, status);
      if (result == true) {
        var selectedIndex = _profiles.indexWhere((e) => e.userId == userId);
        _getNextProfileThenAddDistinct();
        _replaceProfile(selectedIndex);
        _currentProfile = _profiles.first;
        print("Current: ${_currentProfile!.name}");
        notifyListeners();
      }
    } on Exception catch (e) {
      ErrorHelper.showError(message: e.toString());
    }
  }

  int getCurrentIndex() {
    return _profiles
        .indexWhere((element) => element.userId == _currentProfile!.userId);
  }

  setCurrentProfileByIndex(int index) {
    _currentProfile = profiles[index];
  }

  Future<ProfileInfoModel?> getProfileInfo() async {
    try {
      var userId = _currentProfile!.userId;
      _info = await MatchService().getProfileInfo(userId);
      return _info;
    } on Exception catch (e) {
      ErrorHelper.showError(message: e.toString());
    }
    return null;
  }

  // Private methods
  _replaceProfile(int index) {
    print("Removed ${_profiles[index].name}");
    _profiles.removeAt(index);
  }

  _getNextProfileThenAddDistinct() async {
    var nextProfiles = await MatchService().getListProfiles(_limit, _offset);
    _addDistinct(nextProfiles);
  }

  _addDistinct(List<ProfileModel> nextProfiles) {
    Map<String, ProfileModel> profilesMap = {
      for (var profile in _profiles) profile.userId: profile
    };

    for (var profile in nextProfiles) {
      profilesMap.putIfAbsent(profile.userId, () => profile);
    }

    _profiles = profilesMap.values.toList();
  }
  // End private methods
}
