import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay_app/views/player_view.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';

class SmallPlayerControls extends StatefulWidget {
  SmallPlayerControls({Key? key}) : super(key: key);

  @override
  _SmallPlayerControlsState createState() => _SmallPlayerControlsState();
}

class _SmallPlayerControlsState extends State<SmallPlayerControls> {
  @override
  Widget build(BuildContext context) {
    if (!AudioService.playbackState.playing) return SizedBox(height: 0, width: 0);

    return Hero(
      tag: "smallplayercontrolshero",
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          if (details.delta.dy < -5) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PlayerView()));
        },
        child: Container(
          height: 150.0,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
