import 'package:flutter/material.dart';

import 'package:cakeplay/models/storage_handler.dart';
import 'package:cakeplay/widgets/collection_button.dart';

class FolderView extends StatefulWidget {
  @override
  _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 15.0,
    crossAxisSpacing: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    List<String> _directories = StorageHandler.listDirectories();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ordner"),
      ),
      body: Container(
        width: double.infinity,
        child: GridView.builder(
          itemCount: _directories.length,
          gridDelegate: _gridDelegate,
          padding: EdgeInsets.all(15.0),
          itemBuilder: (context, index) => CollectionButton(
            path: _directories[index],
            imagePath: "${_directories[index]}/artwork.png",
          ),
        ),
      ),
    );
  }
}
