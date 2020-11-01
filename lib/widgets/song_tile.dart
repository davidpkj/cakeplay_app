import 'package:flutter/material.dart';

import 'package:cakeplay/constants.dart';
import 'package:cakeplay/views/song_view.dart';
import 'package:cakeplay/models/song_class.dart';

class SongTile extends StatelessWidget {
  SongTile(this.song);

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        song.title,
        style: cSongItemStyle,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongView(
              song: song,
            ),
          ),
        );
      },
    );
  }
}
