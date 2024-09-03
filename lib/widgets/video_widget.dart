import 'package:flutter/material.dart';
import 'package:midia_player/controllers/player_controller.dart';
import 'package:video_player_win/video_player_win.dart';

class VideoWidget extends StatelessWidget {
  final WinVideoPlayerController videoController;
  final PlayerController playerController;

  const VideoWidget({
    required this.videoController,
    required this.playerController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: playerController,
        builder: (context, child) {
          if (videoController.value.isInitialized) {
            return SizedBox.expand(
              child: WinVideoPlayer(videoController),
            );
          }
          return Container();
        });
  }
}
