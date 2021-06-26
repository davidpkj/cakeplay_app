import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/widgets/song_entry.dart';
import 'package:cakeplay_app/models/folder_class.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';
import 'package:cakeplay_app/widgets/small_player_controls.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({Key? key, required this.folder}) : super(key: key);

  final Folder folder;

  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SmallPlayerControls(),
      body: FutureBuilder<List<String>>(
        future: StorageHandler.listDirectoryContent(widget.folder.path, DirectoryContentType.File),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildContent(snapshot.data!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFlexibleSpace() {
    return UnconstrainedBox(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          width: 175.0,
          height: 175.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: FileImage(File.fromUri(widget.folder.artworkUri)),
              fit: BoxFit.fitWidth,
            ),
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      primary: true,
      pinned: true,
      elevation: 10.0,
      title: Text(widget.folder.path.split('/').last),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildContent(List<String> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0) return _buildFlexibleSpace();

          Song song = Song.fromPath(fullPath: list[index - 1]);

          return SongEntry(song: song);
        },
        childCount: list.length + 1,
      ),
    );
  }
}
