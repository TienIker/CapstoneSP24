import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<String> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? "";
  }
}
