import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DirectoryContentType { Directory, File }

class StorageHandler {
  static List<String> favorites = [];
  static Uri? appDirectoryArtwork;

  // TODO: Filter functions basically the same
  static String? _filterDirectory(FileSystemEntity file) {
    String _path = file.path;

    if (_path.split("/").last.startsWith(".")) return null;
    if (Directory(_path).existsSync() && !_path.startsWith(".")) {
      return _path;
    }
  }

  static String? _filterMusicFile(FileSystemEntity file) {
    String _path = file.path;

    if (_path.split("/").last.startsWith(".")) return null;
    if (_path.endsWith(".mp3") || _path.endsWith(".opus")) {
      return _path;
    }
  }

  static Future<List<String>> listDirectoryContent(String directoryPath, DirectoryContentType type) async {
    List<String> _result = [];
    Completer<List<String>> _completer = Completer();
    Stream<FileSystemEntity> _stream = Directory(directoryPath).list();

    Function _filterFunction = _filterMusicFile;

    if (type == DirectoryContentType.Directory) _filterFunction = _filterDirectory;

    _stream.listen((FileSystemEntity _file) {
      String? _path = _filterFunction(_file);

      if (_path != null) _result.add(_path);
    }, onDone: () => _completer.complete(_result));

    return _completer.future;
  }

  static Future<void> saveFavorites() async {
    final _prefs = await SharedPreferences.getInstance();

    _prefs.setString("favorites", json.encode(favorites));
  }

  static Future<void> loadFavorites() async {
    final _prefs = await SharedPreferences.getInstance();
    final List<dynamic> _tempMap = json.decode(_prefs.getString("favorites") ?? "[]");

    if (_tempMap.isNotEmpty) {
      _tempMap.forEach((element) {
        favorites.add(element);
      });
    }
  }

  static Future<void> initFileUris() async {
    // TODO: Improve
    Directory _appDirectory = await getApplicationSupportDirectory();

    File _file = File("${_appDirectory.path}/artwork.png");
    ByteData _byteData = await rootBundle.load("assets/images/artwork.png");
    List<int> _bytes = _byteData.buffer.asUint8List(_byteData.offsetInBytes, _byteData.lengthInBytes);

    _file.writeAsBytes(_bytes);

    appDirectoryArtwork = _file.uri;
  }
}
