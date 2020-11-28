import 'package:flutter/material.dart';

import 'package:cakeplay/text_styles.dart';
import 'package:cakeplay/widgets/settings_tile.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 10.0,
            title: Text("Settings"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 7.0),
                  child: Center(
                    child: Text(
                      "Appearance",
                      style: cSettingsSectionStyle,
                    ),
                  ),
                ),
                SettingsTile(
                  id: "darkmode",
                  title: "Darkmode",
                ),
                SettingsTile(
                  id: "restrictedSearch",
                  title: "Restricted seatch",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
