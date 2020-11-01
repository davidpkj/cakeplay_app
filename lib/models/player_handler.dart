import 'dart:io';
import 'dart:math';

import 'package:just_audio/just_audio.dart';

import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/models/storage_handler.dart';

class PlayerHandler {
  static final _player = AudioPlayer();
  static List<String> _history = List<String>();
  static Song _currentSong; // this is mainly to manage the player state (ie which song to play when)
  static Song _loadedSong; // this is to ask the player for details on the current viewable song

  // TODO: Implement smart shuffle: i.e. not picking the same song in one playlist
  static bool _shuffle;
  static bool _repeat;

/*
  static Future<Duration> load(String path) async {
    if (_player.playerState.playing) {
      final _tempPlayer = AudioPlayer();

      duration = await _tempPlayer.setFilePath(path);
      return duration;
    }

    duration = await _player.setFilePath(path);
    return duration;

  }
  */

  static Future<void> preload(Song song) async {
    _loadedSong = song;
  }

  static Future<void> playpause() async {
    if (_loadedSong != null && _loadedSong != _currentSong) {
      _player.stop();
      _currentSong = _loadedSong;
      _player.setFilePath(_currentSong.path);
    }

    if (_player.playing) {
      _player.pause();
    } else {
      if (!_history.contains(currentSong.path)) _history.add(currentSong.path);

      await _player.play();

      if (_player.processingState == ProcessingState.completed) {
        playNext();
      }
    }
  }

  // TODO: This is shuffle, implement normal next
  static String _nextSongPath(String file, List<String> files) {
    int random = Random().nextInt(files.length);

    while (files[random] == file) {
      random = Random().nextInt(files.length);
    }

    return files[random];
  }

  static Future<void> playNext() async {
    File _file = File(_loadedSong.path);
    List<String> _files = StorageHandler.listMusicFiles(_file.parent.path);

    await preload(Song.fromPath(fullPath: _nextSongPath(_file.path, _files)));

    playpause();
  }

  static String _lastSongPath(String file) {
    int index = _history.indexOf(file);

    if (index > 0) return _history[index--];

    return file;
  }

  static Future<void> playPrevious() async {
    File _file = File(_currentSong.path);

    await preload(Song.fromPath(fullPath: _lastSongPath(_file.path)));

    playpause();
  }

  static Future<void> seekTo(double percent) async {
    if (_player.duration != null) {
      _player.seek(_player.duration * percent);
    }
  }

  static Song get currentSong => _currentSong;
  static bool get isPlaying => _player.playing;
  static Duration get songLength => _player.duration;
  static Duration get currentPosition => _player.position;
}
