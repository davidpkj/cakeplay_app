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
  bool draging = false;
  double _value = 0.0;
  Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (!draging) {
        try {
          _value = await AudioService.customAction("getPositionRelative");
          setState(() {});
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Slider(
            value: _value,
            onChangeStart: (_) {
              draging = true;
            },
            onChanged: (double value) {
              setState(() {
                _value = value;
              });
            },
            onChangeEnd: (double value) {
              draging = false;
              AudioService.customAction("seekToRelative", value);
            },
          ),
        ),
        _buildVariableControls(),
        _buildPlayerControls(),
      ],
    );
  }

  // TODO: This is still useless
  Widget _buildVariableControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.shuffle_rounded,
              color: cTextColor,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              Icons.favorite_border_rounded,
              color: cTextColor,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              Icons.repeat_rounded,
              color: cTextColor,
            ),
            onPressed: null,
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
