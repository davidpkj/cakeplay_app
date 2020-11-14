import 'package:cakeplay/constants.dart';
import 'package:flutter/material.dart';

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
          children: [
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
            )
          ],
        ),
      ),
    );
  }
}
