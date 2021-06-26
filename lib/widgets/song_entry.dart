import 'package:flutter/material.dart';

import 'package:cakeplay_app/views/player_view.dart';
import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';

class SongEntry extends StatelessWidget {
  SongEntry({Key? key, required this.song, this.refreshCallback}) : super(key: key);

  final Song song;
  final Function? refreshCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        song.title,
        style: AppTheme.songEntryTitleStyle,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: AppTheme.songEntrySubtitleStyle,
      ),
      /*
      trailing: Text(
        "2:31",
        style: AppTheme.songEntrySubtitleStyle.copyWith(fontSize: 14.0),
      ),
      */
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerView(song: song)));

        if (refreshCallback != null) refreshCallback!();
      },
    );
  }
}
