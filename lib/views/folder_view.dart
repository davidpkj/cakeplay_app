import 'package:flutter/material.dart';

import 'package:cakeplay_app/models/folder_class.dart';
import 'package:cakeplay_app/widgets/folder_button.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';

class FolderView extends StatefulWidget {
  FolderView({Key? key}) : super(key: key);

  @override
  _FolderViewState createState() => _FolderViewState();
}

// TODO: Refactor
// TODO: Sometimes wierd spinner turns up
class _FolderViewState extends State<FolderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: StorageHandler.listDirectoryContent("/storage/emulated/0/Music/", DirectoryContentType.Directory),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(List<String> data) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.845,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: FolderButton(
            style: FolderMode.full,
            folder: Folder.fromPath(fullPath: data[index]),
          ),
        );
      },
      itemCount: data.length,
    );
  }
}
