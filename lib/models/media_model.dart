import 'dart:io';

class MediaModel {
  final File file;
  final bool isVideo;

  MediaModel({required this.file}) : isVideo = file.path.endsWith('.mp4');
}
