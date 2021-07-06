import 'package:flutter/material.dart';

import 'package:cakeplay_app/handlers/settings_handler.dart';

class AppTheme {
  static bool _darkmode = SettingsHandler.settings["darkmode"]!;

  static Color textColor = _darkmode ? Color(0xFFFAFAFA) : Color(0xFF121212);
  static Color primaryColor = Color(0xFFFB2841);
  static Color secondaryColor = _darkmode ? Color(0xFF121212) : Color(0xFFFAFAFA);
  static Brightness brightness = _darkmode ? Brightness.dark : Brightness.light;
  static MaterialColor swatchColor = Colors.red;

  static TextStyle textStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16.0,
  );

  static TextStyle titleStyle = TextStyle(
    fontFamily: "Montserrat",
    color: primaryColor,
    fontSize: 18.0,
  );

  static TextStyle folderTextStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 15.0,
  );

  static TextStyle songEntryTitleStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16.0,
  );

  static TextStyle songEntrySubtitleStyle = TextStyle(
    fontFamily: "Comfortaa",
    color: Colors.grey,
    fontSize: 12.0,
  );

  static TextStyle playerTitleStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 20.0,
  );

  static TextStyle playerSubtitleStyle = TextStyle(
    fontFamily: "Comfortaa",
    color: Colors.grey,
    fontSize: 16.0,
  );

  static TextStyle permissionTextStyle = TextStyle(
    fontFamily: "Montserrat",
    color: Colors.white,
    fontSize: 20.0,
  );

  static TextStyle permissionButtonTextStyle = TextStyle(
    color: primaryColor,
    fontFamily: "Montserrat",
    fontSize: 18.0,
  );

  static TextStyle navigationBarText = TextStyle(
    color: primaryColor,
    fontFamily: "Montserrat",
    fontSize: 16.0,
  );

  static IconThemeData selectedNavigationIconTheme = IconThemeData(
    color: primaryColor,
  );

  static IconThemeData unselectedNavigationIconTheme = IconThemeData(
    color: Colors.grey,
  );

  static ThemeData asThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      primarySwatch: swatchColor,
      scaffoldBackgroundColor: secondaryColor,
      iconTheme: IconThemeData(color: primaryColor),
      appBarTheme: AppBarTheme(
        brightness: brightness,
        actionsIconTheme: IconThemeData(color: secondaryColor),
        iconTheme: IconThemeData(color: primaryColor),
        color: secondaryColor,
        centerTitle: true,
        elevation: 10.0,
        textTheme: TextTheme(
          headline6: titleStyle,
        ),
      ),
    );
  }
}
