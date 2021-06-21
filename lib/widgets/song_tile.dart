import 'package:flutter/material.dart';

import 'package:cakeplay/text_styles.dart';
import 'package:cakeplay/views/song_view.dart';
import 'package:cakeplay/models/song_class.dart';

class SongTile extends StatelessWidget {
  SongTile({required this.song, this.refreshCallback});

  final Song song;
  final Function? refreshCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        song.title,
        style: cSongItemStyle,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongView(
              song: song,
            ),
          ),
        );

        if (refreshCallback != null) refreshCallback!();
      },
    );
  }
}
