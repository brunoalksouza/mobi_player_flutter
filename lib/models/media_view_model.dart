import 'dart:async';
import 'dart:io';
import '../env.dart';
import '../models/media_model.dart';

class MediaViewModel {
  List<MediaModel> _midias = [];
  int _indiceAtual = 0;
  Timer? _timer;
  void Function()? _onUpdate;

  List<MediaModel> get midias => _midias;
  int get indiceAtual => _indiceAtual;
bool get hasMidia => _midias.isNotEmpty;

  MediaViewModel() {
    _carregarMidias();
    if (hasMidia) {
      _iniciarCicloMidias();
    }
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
  }

  void iniciarCicloMidias() {
    if (_midias.isNotEmpty) {
      _configurarMidiaAtual();
    } else {
      _onUpdate?.call();
    }
  }

  void _configurarMidiaAtual() {
    final midiaAtual = _midias[_indiceAtual];

    if (midiaAtual.isVideo) {
      // Do nothing here; wait for video to end
    } else {
      _timer = Timer(const Duration(seconds: 15), _proximaMidia);
    }
    _onUpdate?.call();
  }

  void _proximaMidia() {
    _indiceAtual = (_indiceAtual + 1) % _midias.length;
    _configurarMidiaAtual();
  }

  void onVideoEnd() {
    _proximaMidia();
  }

  void dispose() {
    _timer?.cancel();
  }
}
