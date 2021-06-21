import 'dart:io';

class StorageHandler {
  static List<String> listDirectories() {
    List<String> _result = [];
    List<FileSystemEntity> _directory = Directory("/storage/emulated/0/Music/").listSync();

    for (FileSystemEntity _entity in _directory) {
      if (Directory(_entity.path).existsSync() && !_entity.path.startsWith(".")) _result.add(_entity.path);
    }

    return _result;
  }

  static List<String> listMusicFiles(String path) {
    List<String> _result = [];
    List<FileSystemEntity> _directory = Directory(path).listSync();

    for (FileSystemEntity _entity in _directory) {
      String file = _entity.path;

      if (!file.startsWith(".") && (file.endsWith(".mp3")) || file.endsWith(".opus")) _result.add(file);
    }

    return _result;
  }
}
