import 'dart:convert';

final class CommonHelper {
  static bool isJsonCompatible(dynamic data) {
    if (data is Map || data is List) {
      // Data is already a JSON-compatible type
      return true;
    } else if (data is String) {
      // Try parsing the string to see if it's valid JSON
      try {
        jsonDecode(data);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      // Data is neither a Map, List, nor a valid JSON string
      return false;
    }
  }
}
