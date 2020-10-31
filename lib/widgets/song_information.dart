import 'package:cakeplay/constants.dart';
import 'package:flutter/material.dart';

class SongInformation extends StatelessWidget {
  SongInformation(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            title ?? "Unknown Title",
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
