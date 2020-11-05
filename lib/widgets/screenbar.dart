import 'package:cakeplay/constants.dart';
import 'package:flutter/material.dart';

class ScreenBar extends StatelessWidget {
  ScreenBar({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: cPrimaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Center(
            child: Text(
              title,
              style: cTitleStyle,
            ),
          ),
          SizedBox(
            width: 44.0,
          )
        ],
      ),
    );
  }
}