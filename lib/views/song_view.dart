import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/widgets/screenbar.dart';
import 'package:cakeplay/widgets/song_image.dart';
import 'package:cakeplay/widgets/song_controls.dart';
import 'package:cakeplay/widgets/song_information.dart';
import 'package:cakeplay/models/background_audio_handler.dart';

void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class SongView extends StatefulWidget {
  SongView({Key key, this.song}) : super(key: key);

  final Song song;

  @override
  _SongViewState createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
  @override
  void initState() {
    super.initState();
    AudioService.start(backgroundTaskEntrypoint: _entrypoint, params: {"path": widget.song.path, "title": widget.song.title});
  }

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
