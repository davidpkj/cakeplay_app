import 'package:flutter/material.dart';

import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/widgets/song_tile.dart';
import 'package:cakeplay/models/storage_handler.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({Key key, this.path}) : super(key: key);

  final String path;

  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    List<String> _files = StorageHandler.listMusicFiles(widget.path);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 10.0,
            title: Text("Some songs"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Song song = Song.fromPath(fullPath: _files[index]);

                return SongTile(song: song);
              },
              childCount: _files.length,
            ),
          ),
        ],
      ),
    );
  }
}
