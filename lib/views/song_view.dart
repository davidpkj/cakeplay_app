import 'package:flutter/material.dart';

import 'package:cakeplay/models/song_class.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Song"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SongImage(widget.song.image),
          SongInformation(widget.song.title),
          SongControls(prefix: widget.song.path, filename: widget.song.title),
        ],
      ),
    );
  }
}
