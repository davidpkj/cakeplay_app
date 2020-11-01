import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/widgets/screenbar.dart';
import 'package:cakeplay/widgets/song_image.dart';
import 'package:cakeplay/models/player_handler.dart';
import 'package:cakeplay/widgets/song_controls.dart';
import 'package:cakeplay/widgets/song_information.dart';

class SongView extends StatefulWidget {
  SongView({Key key, this.song}) : super(key: key);

  final Song song;

  @override
  _SongViewState createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
  @override
  Widget build(BuildContext context) {
    PlayerHandler.preload(widget.song);

    // start playing here, on load, not later
    // TODO: Show new song title, but only after a skip, because else, if a new view is openened, it might be changed instantly
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ScreenBar(title: "Now playing"),
          SongImage(widget.song.image),
          SongInformation(widget.song.title),
          SongControls(prefix: widget.song.path, filename: widget.song.title),
        ],
      ),
    );
  }
}
