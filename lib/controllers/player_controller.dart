import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:midia_player/env.dart';
import 'package:video_player_win/video_player_win.dart';

class PlayerController extends ChangeNotifier {
  List<File> _midias = [];
  int _indiceAtual = 0;
  Timer? _timer;
  WinVideoPlayerController? _videoController;
  final ValueNotifier<int> midiaNotifier = ValueNotifier<int>(0);

  PlayerController() {
    _carregarMidias();
    if (_midias.isNotEmpty) {
      _configurarMidiaAtual();
    }
  }

  List<File> get midias => _midias;
  int get indiceAtual => _indiceAtual;
  WinVideoPlayerController? get videoController => _videoController;

  void _carregarMidias() {
    final dir = Directory(caminhoPasta);
    _midias = dir
        .listSync()
        .where(
          (item) =>
              item is File &&
              (item.path.endsWith('.png') ||
                  item.path.endsWith('.jpg') ||
                  item.path.endsWith('.jpeg') ||
                  item.path.endsWith('.mp4')),
        )
        .map((item) => File(item.path))
        .toList();
    notifyListeners();
  }

  void _configurarMidiaAtual() {
    final midiaAtual = _midias[_indiceAtual];

    if (midiaAtual.path.endsWith('.mp4')) {
      _videoController = WinVideoPlayerController.file(midiaAtual)
        ..initialize().then((_) {
          _videoController?.play();
          _videoController?.setLooping(false);
          _videoController?.addListener(_onVideoEnd);
          changewidget(Duration(
              milliseconds:
                  _videoController?.value.duration.inMilliseconds ?? 0));
        });
    } else {
      changewidget(const Duration(seconds: 5));
    }
    midiaNotifier.value = _indiceAtual;
  }

  void _onVideoEnd() {
    if (_videoController?.value.isInitialized == false &&
        !_videoController!.value.isCompleted) {
      _proximaMidia();
    }
  }

  void _proximaMidia() {
    _indiceAtual = (_indiceAtual + 1) % _midias.length;
    _configurarMidiaAtual();
    notifyListeners();
  }

  void changewidget(Duration duration) {
    _timer?.cancel();
    _timer = Timer(duration, _proximaMidia);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }
}
