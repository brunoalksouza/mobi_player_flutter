import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player_win/video_player_win.dart';

class VideoWidget extends StatefulWidget {
  final String videoPath;
  final Function onVideoEnd;

  const VideoWidget(
      {required this.videoPath, required this.onVideoEnd, Key? key})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late WinVideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WinVideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(false);

        _controller.addListener(() {
          if (_controller.value.isInitialized && !_controller.value.isPlaying) {
            widget.onVideoEnd();
          }
        });
      }).catchError((error) {
        print('Erro ao inicializar o vídeo: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: WinVideoPlayer(_controller),
            ),
          )
        : const CircularProgressIndicator();
  }
}
