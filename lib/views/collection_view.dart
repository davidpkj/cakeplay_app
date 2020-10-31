import 'package:flutter/material.dart';

import 'package:cakeplay/constants.dart';
import 'package:cakeplay/views/song_view.dart';
import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/models/storage_handler.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({Key key, this.path}) : super(key: key);

  final String path;

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  Widget build(BuildContext context) {
    List<String> _files = StorageHandler.listMusicFiles(widget.path);

    // PlayerHandler.loadPlaylist(_files, widget.path);

    return Scaffold(
      appBar: AppBar(
        title: Text("Collection"),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (BuildContext context, int index) {
          Song song = Song.fromPath(fullPath: _files[index]);

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
        },
      ),
    );
  }
}
