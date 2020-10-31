import 'package:cakeplay/widgets/no_permission.dart';
import 'package:flutter/material.dart';

import 'package:cakeplay/constants.dart';
import 'package:cakeplay/views/folder_view.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cakeplay",
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: cSecondaryColor,
        appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(color: cSecondaryColor),
          iconTheme: IconThemeData(color: cSecondaryColor),
          color: cPrimaryColor,
          centerTitle: true,
          elevation: 10.0,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontFamily: "Comfortaa",
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: _checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) return NoPermission();

          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            if (snapshot.data) return FolderView();
          }

          return NoPermission();
        },
      ),
    );
  }

  Future<bool> _checkPermission() async {
    if (!await Permission.storage.isGranted) {
      return false;
    }

    return true;
  }
}
