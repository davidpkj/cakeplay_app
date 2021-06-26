import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cakeplay_app/models/app_theme_class.dart';

class PlayerArtwork extends StatelessWidget {
  PlayerArtwork({Key? key, required this.artworkFile});

  final File artworkFile;

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
    if (artworkFile.existsSync()) {
      return BoxDecoration(
        color: AppTheme.primaryColor,
        image: DecorationImage(
          image: FileImage(artworkFile),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15.0),
      );
    }

    return BoxDecoration(
      color: AppTheme.primaryColor,
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Widget? _buildChild() {
    if (!artworkFile.existsSync()) {
      return Icon(
        Icons.music_note_rounded,
        color: AppTheme.secondaryColor,
        size: 75.0,
      );
    }

    return null;
  }
}
