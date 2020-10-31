import 'dart:io';
import 'dart:math';

import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/models/storage_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

class PlayerHandler extends BackgroundAudioTask {
  static final _player = AudioPlayer();
  static Song _currentSong; // this is mainly to manage the player state (ie which song to play when)
  static Song _loadedSong; // this is to ask the player for details on the current viewable song

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
      await _player.play();

      if (_player.processingState == ProcessingState.completed) {
        playNext();
      }
    }
  }

  // TODO: This is shuffle, implement normal next
  static String _getNewSong(String file, List<String> files) {
    int random = Random().nextInt(files.length);

    while (files[random] == file) {
      random = Random().nextInt(files.length);
    }

    return files[random];
  }

  static Future<void> playNext() async {
    File _file = File(_loadedSong.path);
    List<String> _files = StorageHandler.listMusicFiles(_file.parent.path);

    await preload(Song.fromPath(fullPath: _getNewSong(_file.path, _files)));

    playpause();
  }

  static Future<void> playPrevious() async {}

  static Future<void> seekTo(double percent) async {
    if (_player.duration != null) {
      _player.seek(_player.duration * percent);
    }
  }

  static Song get currentSong => _currentSong;
  static bool get isPlaying => _player.playing;
  static Duration get songLength => _player.duration;
  static Duration get currentPosition => _player.position;

/*
  static Future<void> loadPlaylist(List<String> pathList, String prefix) async {
    for (String path in pathList) {
      _children.add(AudioSource.uri(Uri(path: "$prefix/$path.mp3")));
    }

    _player.load(ConcatenatingAudioSource(children: _children));
  }

  static void playpause(String prefix, String filename) {
    int _index = _children.indexWhere((AudioSource source) => source.toJson()["uri"] == Uri(path: "$prefix/$filename.mp3").path);

    if (_player.playerState.playing) {
      if (currentlyPlaying == filename) {
        _player.pause();
      } else {
        _player.stop();
        _player.seek(Duration(milliseconds: 0), index: _index);
        currentlyPlaying = filename;
        _player.play();
      }

      return;
    }

    // if (_player.playbackState == AudioPlaybackState.paused || _player.playbackState == AudioPlaybackState.stopped) _player.play();
    _player.play();
  }

  static void seekTo(double relativeValue) {
    print(_duration);
    // _player.seek()
  }

  static void playNext() {
    _player.seekToNext();
  }

  static void playPrevious() {
    _player.seekToPrevious();
  }

  static void playlistShuffle() {}

  static void playlistRepeat() {}
  */
}
