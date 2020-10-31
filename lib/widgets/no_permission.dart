import 'package:cakeplay/constants.dart';
import 'package:flutter/material.dart';

class NoPermission extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text(
                "Waiting for storage permission.",
                style: cTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 11.0),
              child: Text(
                "For more information, see the documentation.",
                style: cTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
