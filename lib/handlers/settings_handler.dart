import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsHandler {
  static Map<String, bool> settings = {
    "darkmode": false,
    "restrictedSearch": true,
  };

  static Future<void> save() async {
    final _prefs = await SharedPreferences.getInstance();

    _prefs.setString("settings", json.encode(settings));
  }

  static Future<void> load() async {
    final _prefs = await SharedPreferences.getInstance();
    final Map<String, bool> _tempMap = json.decode(_prefs.getString("settings") ?? "{}") as Map<String, bool>;

    if (_tempMap.isNotEmpty) settings.addAll(_tempMap);
  }
}
