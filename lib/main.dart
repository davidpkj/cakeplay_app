import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:audio_service/audio_service.dart';

import 'package:cakeplay/colors.dart';
import 'package:cakeplay/text_styles.dart';
import 'package:cakeplay/views/folder_view.dart';
import 'package:cakeplay/widgets/no_permission.dart';
import 'package:cakeplay/models/settings_handler.dart';
import 'package:cakeplay/models/favorites_storage_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FavoritesStorageHandler.load();

  runApp(AppRoot());
}

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));

    // TODO: Darkmode
    return MaterialApp(
      title: "Cakeplay",
      theme: _generateThemeData(),
      home: AudioServiceWidget(
        child: FutureBuilder(
          future: _checkPermission(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return NoPermission();

            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              if (snapshot.data == true) return FolderView();

              return NoPermission(requestAgainCallback: _requestAgain);
            }

            return NoPermission();
          },
        ),
      ),
    );
  }

  _requestAgain() {
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (!await Permission.storage.request().isGranted) {
      return false;
    }

    return true;
  }

  ThemeData _generateThemeData() {
    if (SettingsHandler.settings["darkmode"]) {
      vBrightness = Brightness.dark;

      vTextColor = Color(0xFFFFFFFF);
      vPrimaryColor = Color(0xFFFB2841);
      vSecondaryColor = Color(0xFF121212);
      vSwatchColor = Colors.red;
    }

    return ThemeData(
      primaryColor: vPrimaryColor,
      primarySwatch: vSwatchColor,
      scaffoldBackgroundColor: vSecondaryColor,
      iconTheme: IconThemeData(color: vPrimaryColor),
      appBarTheme: AppBarTheme(
        brightness: vBrightness,
        actionsIconTheme: IconThemeData(color: vSecondaryColor),
        iconTheme: IconThemeData(color: vPrimaryColor),
        color: vSecondaryColor,
        centerTitle: true,
        elevation: 10.0,
        textTheme: TextTheme(
          headline6: cTitleStyle,
        ),
      ),
    );
  }
}
