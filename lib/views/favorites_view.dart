import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/models/storage_handler.dart';
import 'package:cakeplay/widgets/song_tile.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    // get path from local storage - containing list of all paths to all fav songs
    List<String> _files = StorageHandler.listMusicFiles("/storage/emulated/0/Music/");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 10.0,
            title: Text("Favorites"),
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

                return SongTile(song);
              },
            ),
          ),
        ],
      ),
    );
  }
}
