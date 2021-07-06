import 'dart:io';

import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/widgets/player_artwork.dart';
import 'package:cakeplay_app/widgets/player_controls.dart';
import 'package:cakeplay_app/widgets/player_information.dart';

class PlayerView extends StatefulWidget {
  PlayerView({Key? key, required this.restartAudioServiceCallback, required this.animateToHomeCallback, this.song}) : super(key: key);

  final Function restartAudioServiceCallback;
  final Function animateToHomeCallback;
  final Song? song;

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          widget.animateToHomeCallback();
          return false;
        },
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.delta.dy > 5) Navigator.pop(context);
          },
          child: StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream.asBroadcastStream(),
            builder: (BuildContext context, AsyncSnapshot<MediaItem?> snapshot) {
              if (snapshot.data == null) {
                if (!AudioService.running) {
                  widget.restartAudioServiceCallback();
                  return Center(child: CircularProgressIndicator());
                }

                // TODO: Prettify
                return Text("Start a song!");
              }

              Uri _artworkUri = snapshot.data?.artUri ?? widget.song!.artworkUri;
              String _path = snapshot.data?.id ?? widget.song!.path;
              Song _song = Song.fromPath(fullPath: _path);

              // FIXME: Spacing
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
}
