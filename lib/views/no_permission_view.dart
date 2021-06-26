import 'package:flutter/material.dart';

import 'package:cakeplay_app/models/app_theme_class.dart';

class NoPermissionView extends StatelessWidget {
  NoPermissionView({this.requestAgainCallback});

  final Function? requestAgainCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    if (requestAgainCallback != null) {
      return [
        Container(),
        Icon(
          Icons.music_note,
          color: Colors.white,
          size: 150.0,
        ),
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            "This app needs to scan your files to work. Please grant permission to storage.",
            style: AppTheme.permissionTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Grant permission",
              style: AppTheme.permissionButtonTextStyle,
            ),
          ),
          onPressed: () {
            requestAgainCallback!();
          },
        ),
      ];
    } else {
      return [
        CircularProgressIndicator(
          color: Colors.white,
        ),
      ];
    }
  }
}
