import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audio_service/audio_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:cakeplay_app/views/main_view.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';
import 'package:cakeplay_app/views/no_permission_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SettingsHandler.load();
  await StorageHandler.loadFavorites();
  await StorageHandler.initFileUris();

  runApp(AppRoot());
}

class AppRoot extends StatefulWidget {
  AppRoot({Key? key}) : super(key: key);

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
      theme: AppTheme.asThemeData(),
      home: AudioServiceWidget(
        child: Builder(
          builder: (BuildContext context) => FutureBuilder(
            future: _checkPermission(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) return NoPermissionView();

              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                if (snapshot.data == true) return MainView();

                return NoPermissionView(requestAgainCallback: _requestAgain);
              }

              return NoPermissionView();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _requestAgain() async {
    setState(() {});
  }

  Future<bool> _checkPermission(BuildContext context) async {
    PermissionStatus permission = await Permission.storage.request();
    if (permission.isGranted) {
      return true;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: new Text("Permission not granted"),
        content: new Text("Alternatively you can grant permission in the settings."),
        actions: <Widget>[
          new TextButton(
            child: new Text("Open settings"),
            onPressed: () async {
              await openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    return false;
  }
}
