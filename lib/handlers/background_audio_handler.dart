import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  static final _player = AudioPlayer();
  static final _history = [];
  static bool _repeat = false;
  static Uri? _appDirectoryArtworkUri;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  _getCurrentMediaItem() async {
    return AudioService.currentMediaItem;
  }

  _refreshMediaItem(Song song) async {
    List<String> path = song.path.split("/");

    MediaItem mediaItem = MediaItem(
      id: song.path,
      title: song.title,
      album: path[path.length - 2],
      artist: song.artist,
      artUri: song.artworkUri, // TODO: Make the artwork definetly square, temp file
    );

    AudioServiceBackground.setMediaItem(mediaItem);
  }

  _seekToRelative(double value) async {
    if (_player.duration != null) {
      _player.seek(_player.duration! * value);
    }
  }

  _getPositionRelative() async {
    if (_player.duration != null) {
      return (_player.position.inMilliseconds / _player.duration!.inMilliseconds).toDouble();
    }

    return 0.0;
  }

  // TODO: Implement smart shuffle
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
    // FIXME: Efficiently determine next song
    List<String> _files = await StorageHandler.listDirectoryContent(_file.parent.path, DirectoryContentType.File);

    await _load(Song.fromPath(fullPath: await _nextSongPath(_file.path, _files), fallbackArtworkUri: _appDirectoryArtworkUri));
  }

  _playPrevious() async {
    if (_history.length > 1) {
      _history.removeLast();
      await _load(Song.fromPath(fullPath: _history[_history.length - 1], fallbackArtworkUri: _appDirectoryArtworkUri));
    } else {
      _player.seek(Duration(milliseconds: 0));
    }
  }

  _load(Song song) async {
    if (_history.isEmpty || _history.last != song.path) _history.add(song.path);

    await _player.setFilePath(song.path); // FIXME: Player aborted exception occurs sometimes  // if (_player.processingState == ProcessingState.loading)
    _refreshMediaItem(song);

    await _player.play();
  }

  _toggleRepeat() async {
    _repeat = !_repeat;

    return _repeat;
  }

  _getProcessingState() {
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }

  _broadcastState() async {
    AudioServiceBackground.setState(
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      processingState: _getProcessingState(),
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      androidCompactActions: [0, 1, 3],
    );
  }

  @override
  onCustomAction(String id, dynamic value) async {
    switch (id) {
      case "load":
        await _load(value);
        break;
      case "getCurrentMediaItem":
        await _getCurrentMediaItem();
        break;
      case "seekToRelative":
        await _seekToRelative(value);
        break;
      case "getPositionRelative":
        return Future.value(await _getPositionRelative());
      case "toggleRepeat":
        return Future.value(await _toggleRepeat());
    }
  }

  @override
  onStart(Map<String, dynamic>? params) async {
    if (params == null || params["path"] == null) return;

    if (params["appDirectoryArtwork"] != null) _appDirectoryArtworkUri = Uri.parse("file://${params["appDirectoryArtwork"]}");
    Song song = Song.fromPath(fullPath: params["path"], fallbackArtworkUri: _appDirectoryArtworkUri);

    _refreshMediaItem(song);

    _eventSubscription = _player.playbackEventStream.listen((event) {
      _broadcastState();
    });

    // TODO: On end, if loop not set, set the play/pause button to "play" and on press, repeat song
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
    _eventSubscription.cancel();
    await _player.dispose();
    await _broadcastState();
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
