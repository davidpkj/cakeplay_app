import 'package:flutter/material.dart';

import 'package:cakeplay/text_styles.dart';
import 'package:cakeplay/models/settings_handler.dart';

class SettingsTile extends StatefulWidget {
  SettingsTile({required this.id, required this.title, this.description});

  final String id;
  final String title;
  final String? description;

  @override
  _SettingsTileState createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: cSettingsTileTitleStyle,
      ),
      subtitle: widget.description != null
          ? Text(
              widget.description!,
              style: cSettingsTileDescriptionStyle,
            )
          : null,
      trailing: Switch(
        value: SettingsHandler.settings[widget.id]!,
        onChanged: (change) {
          SettingsHandler.settings[widget.id] = change;
          setState(() {});
        },
      ),
    );
  }
}
