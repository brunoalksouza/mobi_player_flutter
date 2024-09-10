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
    if (!dir.existsSync()) {
      return;
    }

    _midias = dir
        .listSync()
        .where(
          (item) =>
              item is File &&
              (item.path.endsWith('.png') ||
                  item.path.endsWith('.jpg') ||
                  item.path.endsWith('.jpeg') ||
                  item.path.endsWith('.webp') ||
                  item.path.endsWith('.gif') ||
                  item.path.endsWith('.mp4') ||
                  item.path.endsWith('.mkv') ||
                  item.path.endsWith('.avi') ||
                  item.path.endsWith('.mov')),
        )
        .map((item) => File(item.path))
        .toList();
    notifyListeners();
  }

  Future<void> _configurarMidiaAtual() async {
    if (_midias.isEmpty) return;

    final midiaAtual = _midias[_indiceAtual];

    if (midiaAtual.path.endsWith('.mp4') ||
        midiaAtual.path.endsWith('.mkv') ||
        midiaAtual.path.endsWith('.avi') ||
        midiaAtual.path.endsWith('.mov')) {
      _videoController = WinVideoPlayerController.file(midiaAtual);
      await _videoController!.initialize();
      await _videoController!.setLooping(false);
      await _videoController!.play();
      changewidget(Duration(
          milliseconds: _videoController?.value.duration.inMilliseconds ?? 0));
    } else {
      changewidget(const Duration(seconds: 15));
    }
    midiaNotifier.value = _indiceAtual;
  }

  void _onVideoEnd() {
    if (_videoController?.value.isInitialized == false &&
        !_videoController!.value.isCompleted) {
      _proximaMidia();
    }
  }

  Future<void> _proximaMidia() async {
    if (_midias.isEmpty) return;
    _indiceAtual = (_indiceAtual + 1) % _midias.length;
    await _configurarMidiaAtual();
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
