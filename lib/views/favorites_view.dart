import 'package:flutter/material.dart';

import 'package:cakeplay/models/favorites_storage_handler.dart';
import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/widgets/song_tile.dart';

class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    List<String> _files = FavoritesStorageHandler.favorites;

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

                return SongTile(
                  song: song,
                  refreshCallback: _refresh,
                );
              },
              childCount: _files.length,
            ),
          ),
        ],
      ),
    );
  }

  _refresh() {
    setState(() {});
  }
}
