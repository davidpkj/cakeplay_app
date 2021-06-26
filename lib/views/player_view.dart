import 'dart:io';

import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/widgets/player_artwork.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';
import 'package:cakeplay_app/widgets/player_controls.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';
import 'package:cakeplay_app/widgets/player_information.dart';
import 'package:cakeplay_app/handlers/background_audio_handler.dart';

void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class PlayerView extends StatefulWidget {
  PlayerView({Key? key, this.song}) : super(key: key);

  final Song? song;

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  Future<void> _asyncInit() async {
    if (AudioService.running) await AudioService.stop();
    await AudioService.start(backgroundTaskEntrypoint: _entrypoint, params: {"path": widget.song!.path, "appDirectoryArtwork": StorageHandler.appDirectoryArtwork!.path.toString()});
  }

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "smallplayercontrolshero",
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.delta.dy > 5) Navigator.pop(context);
          },
          child: StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream.asBroadcastStream(),
            builder: (BuildContext context, AsyncSnapshot<MediaItem?> snapshot) {
              Uri _artworkUri = snapshot.data?.artUri ?? widget.song!.artworkUri;
              String _path = snapshot.data?.id ?? widget.song!.path;
              Song _song = Song.fromPath(fullPath: _path);

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFakeAppBar(),
                  PlayerArtwork(artworkFile: File.fromUri(_artworkUri), key: Key(_artworkUri.toString())),
                  PlayerInformation(song: _song),
                  PlayerControls(song: _song),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFakeAppBar() {
    return Container(
      height: 48.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Center(
            child: Text(
              "Now Playing",
              style: AppTheme.titleStyle,
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
