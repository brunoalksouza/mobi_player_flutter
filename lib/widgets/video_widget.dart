import 'package:flutter/material.dart';
import 'package:video_player_win/video_player_win.dart';

class VideoWidget extends StatelessWidget {
  final WinVideoPlayerController videoController;

  const VideoWidget({
    required this.videoController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videoController.value.isInitialized) {
      return SizedBox.expand(
        child: WinVideoPlayer(videoController),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
