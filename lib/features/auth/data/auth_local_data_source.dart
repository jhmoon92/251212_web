import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/rememberme_entity.dart';

const _rememberMeKey = 'remember_me';

class AuthLocalDataSource {
  Future<void> setRememberMe(RememberMe data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_rememberMeKey, jsonString);
  }

  Future<RememberMe?> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_rememberMeKey);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return RememberMe.fromJson(jsonMap);
    } catch (e) {
      print("loadRememberMe error: $e");
      return null;
    }
  }

  Future<void> clearRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
  }
}
