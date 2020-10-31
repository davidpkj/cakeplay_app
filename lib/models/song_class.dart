import 'dart:io';

class Song {
  String path;
  String image;
  String title;

  Song({this.path, this.image, this.title});

  static Song fromPath({String fullPath}) {
    String _name = fullPath.split("/").last;

    return Song(
      path: fullPath,
      title: _name.substring(0, _name.lastIndexOf(".")),
      image: "${File(fullPath).parent.path}/artwork.png",
    );
  }
}
