import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay/constants.dart';

class SongInformation extends StatelessWidget {
  SongInformation(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: StreamBuilder<MediaItem>(
            stream: AudioService.currentMediaItemStream,
            builder: (BuildContext context, AsyncSnapshot<MediaItem> snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return Text(
                  title ?? "Unknown Title",
                  style: cSongTitleStyle,
                  textAlign: TextAlign.center,
                );
              } else {
                return Text(
                  snapshot.data.title ?? "Unknown Title",
                  style: cSongTitleStyle,
                  textAlign: TextAlign.center,
                );
              }
            },
          ),
        ),
        /*
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("${album ?? 'Unknown Album'} - ${artist ?? 'Unknown Artist'}", style: cSongDetailsStyle),
        ),
        */
      ],
    );
  }
}
