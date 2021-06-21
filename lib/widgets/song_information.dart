import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay/text_styles.dart';

class SongInformation extends StatelessWidget {
  SongInformation(this.title);

  final String? title;

  @override
  Widget build(BuildContext context) {
    String title = "Unknown Title";

    AudioService.currentMediaItemStream.listen((event) {
      title = event?.title ?? "Unknown Title";
    });

    // TODO: TEST
    // TODO: Make very long text move
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            title,
            style: cSongTitleStyle,
            textAlign: TextAlign.center,
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
