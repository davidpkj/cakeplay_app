import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:cakeplay/models/song_class.dart';
import 'package:cakeplay/models/storage_handler.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  static final _player = AudioPlayer();
  static final _history = List<String>();
  static bool _repeat = false;

  _refreshMediaItem(Song song) async {
    MediaItem mediaItem = MediaItem(id: song.path, title: song.title, album: "");

    AudioServiceBackground.setMediaItem(mediaItem);
  }

  _seekToRelative(double value) async {
    if (_player.duration != null) {
      _player.seek(_player.duration * value);
    }
  }

  _getPositionRelative() async {
    if (_player.position != null && _player.duration != null) {
      return (_player.position.inMilliseconds / _player.duration.inMilliseconds).toDouble();
    }

    return 0.0;
  }

  // TODO: Everyday im shuffelin
  _nextSongPath(String path, List<String> files) async {
    int random = Random().nextInt(files.length);

    while (files[random] == path) {
      random = Random().nextInt(files.length);
    }

    return files[random];
  }

  _playNext() async {
    if (_repeat) {
      _player.seek(Duration(microseconds: 0));
      return;
    }

    File _file = File(_history[0]);
    List<String> _files = StorageHandler.listMusicFiles(_file.parent.path);

    await _load(Song.fromPath(fullPath: await _nextSongPath(_file.path, _files)));
  }

  _playPrevious() async {
    if (_history.length > 1) {
      _history.removeLast();
      await _load(Song.fromPath(fullPath: _history[_history.length - 1]));
    } else {
      _player.seek(Duration(milliseconds: 0));
    }
  }

  _load(Song song) async {
    if (_history.isEmpty || _history.last != song.path) _history.add(song.path);

    await _player.setFilePath(song.path);
    _refreshMediaItem(song);

    await _player.play();
  }

  _toggleRepeat() async {
    _repeat = !_repeat;

    return _repeat;
  }

  @override
  onCustomAction(String id, dynamic value) async {
    switch (id) {
      case "seekToRelative":
        await _seekToRelative(value);
        break;
      case "getPositionRelative":
        return Future.value(await _getPositionRelative());
      case "playPrevious":
        await _playPrevious();
        break;
      case "playNext":
        await _playNext();
        break;
      case "load":
        await _load(value);
        break;
      case "toggleRepeat":
        return Future.value(await _toggleRepeat());
    }
  }

  @override
  onStart(Map<String, dynamic> params) async {
    Song song = Song.fromPath(fullPath: params["path"]);

    _refreshMediaItem(song);

    _player.playerStateStream.listen((playerState) {
      AudioServiceBackground.setState(
        playing: playerState.playing,
        processingState: {
          ProcessingState.none: AudioProcessingState.none,
          ProcessingState.loading: AudioProcessingState.connecting,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[playerState.processingState],
        controls: [
          playerState.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
        ],
      );
    });

    _player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        _playNext();
      }
    });

    _load(song);
  }

  @override
  onTaskRemoved() async {
    if (!AudioServiceBackground.state.playing) {
      onStop();
    }
  }

  @override
  onPlay() async {
    await _player.play();
  }

  @override
  onPause() async {
    _player.pause();
  }

  @override
  onStop() async {
    await _player.dispose();
    await super.onStop();
  }

  @override
  Future<void> onSkipToNext() {
    _playNext();
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    _playPrevious();
    return super.onSkipToPrevious();
  }
}
