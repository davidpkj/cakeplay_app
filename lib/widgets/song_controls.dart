import 'dart:async';

import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay/constants.dart';

class SongControls extends StatefulWidget {
  SongControls({this.prefix, this.filename});

  final String prefix;
  final String filename;

  @override
  _SongControlsState createState() => _SongControlsState();
}

class _SongControlsState extends State<SongControls> {
  bool _repeat = false;
  bool _draging = false;
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

  _buildSliderControls() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Slider(
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

  // TODO: This is still sorta useless
  Widget _buildVariableControls() {
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
              Icons.favorite_border_rounded,
              color: Colors.grey, // cTextColor,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              Icons.repeat_one_rounded,
              color: _repeat ? cPrimaryColor : cTextColor,
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
              color: cTextColor,
              size: 35.0,
            ),
            onPressed: () {
              AudioService.customAction("playPrevious");
            },
          ),
          FloatingActionButton(
            backgroundColor: cPrimaryColor,
            elevation: 0,
            child: Icon(
              (AudioService.playbackState != null && AudioService.playbackState.playing) ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: cSecondaryColor,
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
              color: cTextColor,
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
