import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorageHandler {
  static List<String> favorites = [];

  static Future<void> save() async {
    final _prefs = await SharedPreferences.getInstance();

    _prefs.setString("favorites", json.encode(favorites));
  }

  static Future<void> load() async {
    final _prefs = await SharedPreferences.getInstance();

    try {
      final _tempList = json.decode(_prefs.getString("favorites") ?? "[]");

      if (_tempList.isEmpty) return;

      _tempList.forEach((element) {
        favorites.add(element);
      });
    } catch (e) {
      print(e);
    }
  }
}
