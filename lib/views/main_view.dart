import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';

import 'package:cakeplay_app/views/folder_view.dart';
import 'package:cakeplay_app/views/player_view.dart';
import 'package:cakeplay_app/views/favorites_view.dart';
import 'package:cakeplay_app/models/app_theme_class.dart';
import 'package:cakeplay_app/handlers/storage_handler.dart';
import 'package:cakeplay_app/handlers/background_audio_handler.dart';

void entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late int _index;
  late PageController _pageController;

  Future<void> _asyncInit() async {
    if (AudioService.running) await AudioService.stop();
    await AudioService.start(backgroundTaskEntrypoint: entrypoint, params: {"appDirectoryArtwork": StorageHandler.appDirectoryArtwork!.path.toString()});
  }

  @override
  void initState() {
    super.initState();
    _asyncInit();

    _index = 2;
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: AppTheme.selectedNavigationIconTheme,
        unselectedIconTheme: AppTheme.unselectedNavigationIconTheme,
        onTap: (newIndex) {
          _index = newIndex;
          _animatePageViewer(index: newIndex);

          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted_rounded), label: "Select"),
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow_rounded), label: "Player"),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          _index = newIndex;

          setState(() {});
        },
        children: [
          // SettingsView(animateToHomeCallback: _animateToHome),
          Container(color: Colors.grey),
          FavoritesView(animateToHomeCallback: _animatePageViewer),
          FolderView(),
          PlayerView(restartAudioServiceCallback: _asyncInit, animateToHomeCallback: _animatePageViewer),
        ],
      ),
    );
  }

  void _animatePageViewer({int index = 2}) {
    _pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }
}
