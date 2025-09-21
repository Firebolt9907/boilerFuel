import 'dart:convert';

import 'package:boiler_fuel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static String userKey = "USER_KEY";
  static User? user;
  static String? userString;

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toMap()));
  }

  static Future<User?> getUser() async {
    if (user != null && userString != null) return user;

    final prefs = await SharedPreferences.getInstance();
    userString = prefs.getString(userKey);
    if (userString == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userString!);
    user = User.fromMap(userMap);
    return user;
  }
}
