import 'package:flutter/material.dart';

import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';

class PlayerInformation extends StatelessWidget {
  PlayerInformation({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    // TODO: Make very long text move, marquee
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            song.title,
            style: AppTheme.playerTitleStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(song.artist, style: AppTheme.playerSubtitleStyle),
        ),
      ],
    );
  }
}
