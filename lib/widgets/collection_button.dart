import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cakeplay/constants.dart';
import 'package:cakeplay/views/collection_view.dart';

class CollectionButton extends StatelessWidget {
  CollectionButton({this.path, this.imagePath});

  final String path;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _buildImage(),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return CollectionView(path: path);
          },
        ));
      },
    );
  }

  Widget _buildImage() {
    if (imagePath != null && File(imagePath).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.memory(
          File(imagePath).readAsBytesSync(),
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      child: Icon(
        Icons.music_note_rounded,
        color: cSecondaryColor,
        size: 75.0,
      ),
      decoration: BoxDecoration(
        color: cPrimaryColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}