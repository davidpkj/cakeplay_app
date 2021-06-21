import 'dart:io';

class Song {
  String path;
  String image;
  String title;

  Song({required this.path, required this.image, required this.title});

  static Song fromPath({required String fullPath}) {
    String _name = fullPath.split("/").last;

    return Song(
      path: fullPath,
      title: _name.substring(0, _name.lastIndexOf(".")),
      image: "${File(fullPath).parent.path}/artwork.png",
    );
  }
}
