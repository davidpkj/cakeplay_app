import 'package:flutter/material.dart';

import 'package:cakeplay/constants.dart';
import 'package:cakeplay/views/favorites_view.dart';
import 'package:cakeplay/models/storage_handler.dart';
import 'package:cakeplay/widgets/collection_button.dart';

class FolderView extends StatefulWidget {
  @override
  _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  @override
  Widget build(BuildContext context) {
    List<String> _directories = StorageHandler.listDirectories();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 10.0,
            title: Text("Folders"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.favorite,
                color: cPrimaryColor,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FavoritesView()));
              },
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CollectionButton(
                    path: _directories[index],
                    imagePath: "${_directories[index]}/artwork.png",
                  ),
                );
              },
              childCount: _directories.length,
            ),
          ),
        ],
      ),
    );
  }
}
