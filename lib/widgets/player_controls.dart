import 'dart:async';

import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay_app/models/song_class.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';

class PlayerControls extends StatefulWidget {
  PlayerControls({required this.song});

  final Song song;

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  bool _isFavorite = false;
  bool _draging = false;
  bool _repeat = false;
  double _value = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (!_draging) {
        // TODO: FIXME: This might be involved with an uncaught exception
        try {
          _value = await AudioService.customAction("getPositionRelative"); // FIXME: This sometimes calls before initialized
          if (0 < _value && _value < 1) setState(() {});
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSliderControls(),
        _buildVariableControls(),
        _buildPlayerControls(),
      ],
    );
  }

  _buildSliderControls() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Slider(
        activeColor: AppTheme.primaryColor,
        inactiveColor: AppTheme.primaryColor.withOpacity(0.3),
        value: _value,
        onChangeStart: (_) {
          _draging = true;
        },
        onChanged: (double value) {
          setState(() {
            _value = value;
          });
        },
        onChangeEnd: (double value) {
          _draging = false;
          AudioService.customAction("seekToRelative", value);
        },
      ),
    );
  }

  Widget _buildVariableControls() {
    List<String> _favorites = StorageHandler.favorites;
    _isFavorite = _favorites.contains(widget.song.path);

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.shuffle_rounded,
              color: Colors.grey, // cPrimaryColor,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? AppTheme.primaryColor : AppTheme.textColor,
            ),
            onPressed: () async {
              if (_isFavorite) {
                _favorites.remove(widget.song.path);
              } else {
                _favorites.add(widget.song.path);
              }

              await StorageHandler.saveFavorites();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(
              Icons.repeat_one_rounded,
              color: _repeat ? AppTheme.primaryColor : AppTheme.textColor,
            ),
            onPressed: () async {
              _repeat = await AudioService.customAction("toggleRepeat");
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.fast_rewind_rounded,
              color: AppTheme.textColor,
              size: 35.0,
            ),
            onPressed: () {
              AudioService.skipToPrevious();
            },
          ),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            child: Icon(
              AudioService.playbackState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: AppTheme.secondaryColor,
              size: 35.0,
            ),
            onPressed: () {
              if (AudioService.playbackState.playing) {
                AudioService.pause();
              } else {
                AudioService.play();
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.fast_forward_rounded,
              color: AppTheme.textColor,
              size: 35.0,
            ),
            onPressed: () {
              AudioService.skipToNext();
            },
          ),
        ],
      ),
    );
  }
}
