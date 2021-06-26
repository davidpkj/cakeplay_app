import 'dart:io';

import 'package:cakeplay_app/handlers/storage_handler.dart';

// TODO: Implement META-Tags and smart title / artist detection
class Song {
  String path;
  String title;
  String artist;
  Uri artworkUri;

  Song({required this.path, required this.title, required this.artist, required this.artworkUri});

  // TODO: Make parse format customizible
  // TODO: Add duration
  static Song fromPath({required String fullPath, Uri? fallbackArtworkUri}) {
    String _name = fullPath.split("/").last;
    _name = _name.substring(0, _name.lastIndexOf("."));
    List<String> _split = _name.split(" - ");
    String _artist = _split.length > 1 ? _split.removeAt(0) : "Unknown Artist";
    String _title = _split.join(" - ");
    File _artwork = File("${File(fullPath).parent.path}/artwork.png");
    Uri? _fallback = StorageHandler.appDirectoryArtwork ?? fallbackArtworkUri;

    return Song(
      path: fullPath,
      title: _title,
      artist: _artist,
      artworkUri: _artwork.existsSync() || _fallback == null ? _artwork.uri : _fallback, // FIXME: This is kinda messed up
    );
  }
}
