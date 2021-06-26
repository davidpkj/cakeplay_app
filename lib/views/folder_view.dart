import 'package:flutter/material.dart';

import 'package:cakeplay_app/models/folder_class.dart';
import 'package:cakeplay_app/widgets/folder_button.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';
import 'package:cakeplay_app/widgets/small_player_controls.dart';

class FolderView extends StatefulWidget {
  @override
  _FolderViewState createState() => _FolderViewState();
}

// TODO: Refactor
// TODO: Sometimes wierd spinner turns up
class _FolderViewState extends State<FolderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SmallPlayerControls(),
      body: FutureBuilder(
        future: StorageHandler.listDirectoryContent("/storage/emulated/0/Music/", DirectoryContentType.Directory),
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

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 10.0,
      title: Text("Folders"),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.favorite),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Container())); // FavoritesView()));
        },
      ),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    return [
      IconButton(
        icon: Icon(
          Icons.settings_rounded,
          color: AppTheme.primaryColor,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Container())); // SettingsView()));
        },
      ),
      IconButton(
        icon: Icon(
          Icons.help_rounded,
          color: AppTheme.primaryColor,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(
          Icons.search_rounded,
          color: AppTheme.primaryColor,
        ),
        onPressed: () {},
      ),
    ];
  }

  Widget _buildContent(List<String> data) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.845,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: FolderButton(
              style: FolderMode.full,
              folder: Folder.fromPath(fullPath: data[index]),
            ),
          );
        },
        childCount: data.length,
      ),
    );
  }
}
