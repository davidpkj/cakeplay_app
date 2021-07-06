import 'package:flutter/material.dart';

import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/widgets/song_entry.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';

class FavoritesView extends StatefulWidget {
  FavoritesView({Key? key, required this.animateToHomeCallback}) : super(key: key);

  final Function animateToHomeCallback;

  @override
  _FavoritesView createState() => _FavoritesView();
}

class _FavoritesView extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          widget.animateToHomeCallback();
          return false;
        },
        child: FutureBuilder(
          future: _getFavoriteSongs(),
          builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) => SongEntry(
                song: snapshot.data![index],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Song>> _getFavoriteSongs() async {
    List<String> _favoritePaths = StorageHandler.favorites;
    List<Song> _result = [];

    for (String path in _favoritePaths) {
      _result.add(Song.fromPath(fullPath: path));
    }

    return _result;
  }
}
