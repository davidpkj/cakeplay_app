import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cakeplay/colors.dart';

class SongImage extends StatelessWidget {
  SongImage(this.image);

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 15.0),
        width: 200.0,
        height: 200.0,
        decoration: _buildDecoration(),
        child: _buildChild(),
      ),
    );
  }

  Decoration _buildDecoration() {
    if (image != null && File(image!).existsSync()) {
      return BoxDecoration(
        color: vPrimaryColor,
        image: DecorationImage(
          image: MemoryImage(
            File(image!).readAsBytesSync(),
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15.0),
      );
    }

    return BoxDecoration(
      color: vPrimaryColor,
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Widget? _buildChild() {
    if (image == null || image!.isEmpty || !File(image!).existsSync()) {
      return Icon(
        Icons.music_note_rounded,
        color: vSecondaryColor,
        size: 75.0,
      );
    }

    return null;
  }
}
