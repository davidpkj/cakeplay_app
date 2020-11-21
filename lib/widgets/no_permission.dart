import 'package:flutter/material.dart';

import 'package:cakeplay/constants.dart';

class NoPermission extends StatelessWidget {
  NoPermission({this.requestAgainCallback});

  final Function requestAgainCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    if (requestAgainCallback != null) {
      return [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            "Please grant storage permission.",
            style: cTextStyle,
          ),
        ),
        RaisedButton(
          color: cPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Grant permission",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
              ),
            ),
          ),
          onPressed: requestAgainCallback,
        ),
      ];
    } else {
      return [
        CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            "Loading something.",
            style: cTextStyle,
          ),
        ),
      ];
    }
  }
}
