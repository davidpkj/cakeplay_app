import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:audio_service/audio_service.dart';

import 'package:cakeplay/constants.dart';
import 'package:cakeplay/views/folder_view.dart';
import 'package:cakeplay/widgets/no_permission.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

    return MaterialApp(
      title: "Cakeplay",
      theme: ThemeData(
        primarySwatch: cSwatchColor,
        scaffoldBackgroundColor: cSecondaryColor,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          actionsIconTheme: IconThemeData(color: cSecondaryColor),
          iconTheme: IconThemeData(color: cPrimaryColor),
          color: cSecondaryColor,
          centerTitle: true,
          elevation: 10.0,
          textTheme: TextTheme(
            headline6: cTitleStyle,
          ),
        ),
      ),
      home: AudioServiceWidget(
        child: FutureBuilder(
          future: _checkPermission(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return NoPermission();

            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              if (snapshot.data) return FolderView();
            }

            return NoPermission(requestAgainCallback: _requestAgain);
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
}
