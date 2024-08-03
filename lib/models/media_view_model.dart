import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../env.dart';
import '../models/media_model.dart';

class MediaViewModel extends ChangeNotifier {
  List<MediaModel> _midias = [];
  int _indiceAtual = 0;
  Timer? _timer;

  List<MediaModel> get midias => _midias;
  int get indiceAtual => _indiceAtual;

  MediaViewModel() {
    _carregarMidias();
    _iniciarCicloMidias();
  }

  void _carregarMidias() {
    final dir = Directory(caminhoPasta);
    _midias = dir
        .listSync()
        .where((item) =>
            item is File &&
            (item.path.endsWith('.png') || item.path.endsWith('.mp4')))
        .map((item) => MediaModel(file: File(item.path)))
        .toList();
    notifyListeners();
  }

  void _iniciarCicloMidias() {
    _configurarMidiaAtual();
  }

  void _configurarMidiaAtual() {
    final midiaAtual = _midias[_indiceAtual];

    if (midiaAtual.isVideo) {
      // Do nothing here; wait for video to end
    } else {
      _timer = Timer(const Duration(seconds: 15), _proximaMidia);
    }
    notifyListeners();
  }

  void _proximaMidia() {
    _indiceAtual = (_indiceAtual + 1) % _midias.length;
    _configurarMidiaAtual();
    notifyListeners();
  }

  void onVideoEnd() {
    _proximaMidia();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
