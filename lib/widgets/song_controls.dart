import 'dart:async';

import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay/colors.dart';
import 'package:cakeplay/models/favorites_storage_handler.dart';

class SongControls extends StatefulWidget {
  SongControls({this.prefix, this.filename});

  final String prefix;
  final String filename;

  @override
  _SongControlsState createState() => _SongControlsState();
}

class _SongControlsState extends State<SongControls> {
  bool _isFavorite = false;
  bool _draging = false;
  bool _repeat = false;
  double _value = 0.0;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (!_draging) {
        // TODO: FIXME: This might be involved with an uncaught exception
        try {
          _value = await AudioService.customAction("getPositionRelative");
          if (0 < _value && _value < 1) setState(() {});
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  // TODO: Make these controls accessible after closing song view -> sexy modal bottom sheet, swipe up/down animation
  _buildSliderControls() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Slider(
        activeColor: vPrimaryColor,
        inactiveColor: vPrimaryColor.withOpacity(0.3),
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
    List<String> _favorites = FavoritesStorageHandler.favorites;
    _isFavorite = _favorites.contains(widget.prefix);

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
              color: _isFavorite ? vPrimaryColor : vTextColor,
            ),
            onPressed: () async {
              if (_isFavorite) {
                _favorites.remove(widget.prefix);
              } else {
                _favorites.add(widget.prefix);
              }

              await FavoritesStorageHandler.save();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(
              Icons.repeat_one_rounded,
              color: _repeat ? vPrimaryColor : vTextColor,
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
              color: vTextColor,
              size: 35.0,
            ),
            onPressed: () {
              AudioService.customAction("playPrevious");
            },
          ),
          FloatingActionButton(
            backgroundColor: vPrimaryColor,
            elevation: 0,
            child: Icon(
              (AudioService.playbackState != null && AudioService.playbackState.playing) ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: vSecondaryColor,
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
              color: vTextColor,
              size: 35.0,
            ),
            onPressed: () {
              AudioService.customAction("playNext");
            },
          ),
        ],
      ),
    );
  }
}
