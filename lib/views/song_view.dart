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
  SongView({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  _SongViewState createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
  _init() async {
    if (AudioService.running) await AudioService.stop();
    await AudioService.start(backgroundTaskEntrypoint: _entrypoint, params: {"path": widget.song.path, "title": widget.song.title});
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    MediaItem? mediaItem = AudioService.currentMediaItem;

    // TODO: Update song information on song change
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ScreenBar(title: "Now playing"),
          SongImage(widget.song.image), //FIXME: Implement changing artwork
          SongInformation(mediaItem?.title ?? widget.song.title),
          SongControls(prefix: widget.song.path, filename: widget.song.title),
        ],
      ),
    );
  }
}
