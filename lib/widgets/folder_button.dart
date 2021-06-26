import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cakeplay_app/views/playlist_view.dart';
import 'package:cakeplay_app/models/folder_class.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';

// TODO: Implement compact view
enum FolderMode { compact, full }

class FolderButton extends StatelessWidget {
  FolderButton({required this.folder, required this.style});

  final Folder folder;
  final FolderMode style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: constraints.maxWidth,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) => GestureDetector(
                  child: _buildImage(constraints),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PlaylistView(folder: folder);
                      },
                    ));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  folder.path.split("/").last,
                  style: AppTheme.folderTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Implement spinner while image loads
  Widget _buildImage(BoxConstraints constraints) {
    File artworkFile = File.fromUri(folder.artworkUri);

    if (artworkFile.existsSync()) {
      return Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth - 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.memory(
            artworkFile.readAsBytesSync(),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      height: constraints.maxWidth,
      child: Container(
        child: Icon(
          Icons.music_note_rounded,
          color: AppTheme.secondaryColor,
          size: 75.0,
        ),
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
