import 'dart:io';

import 'package:cakeplay_app/handlers/storage_handler.dart';

class Folder {
  String path;
  Uri artworkUri;

  Folder({required this.path, required this.artworkUri});

  static Folder fromPath({required String fullPath}) {
    Uri _artworkUri = Uri.parse("file://${File(fullPath).path}/artwork.png");

    if (!File.fromUri(_artworkUri).existsSync()) _artworkUri = StorageHandler.appDirectoryArtwork!;

    return Folder(
      path: fullPath,
      artworkUri: _artworkUri,
    );
  }
}
