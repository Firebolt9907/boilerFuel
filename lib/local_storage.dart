import 'dart:convert';

import 'package:boiler_fuel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static String userKey = "USER_KEY";

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toMap()));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString(userKey);
    if (userString == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userString);
    return User.fromMap(userMap);
  }
}
