import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player_win/video_player_win.dart';
import '../env.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late List<File> _midias;
  late int _indiceAtual;
  Timer? _timer;
  WinVideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _midias = _carregarMidias();
    _indiceAtual = 0;
    _iniciarCicloMidias();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  List<File> _carregarMidias() {
    final dir = Directory(caminhoPasta);
    return dir
        .listSync()
        .where((item) =>
            item is File &&
            (item.path.endsWith('.png') || item.path.endsWith('.mp4')))
        .map((item) => File(item.path))
        .toList();
  }

  void _iniciarCicloMidias() {
    _configurarMidiaAtual();
  }

  void _configurarMidiaAtual() async {
    final midiaAtual = _midias[_indiceAtual];

    if (midiaAtual.path.endsWith('.mp4')) {
      _videoController?.dispose();
      _videoController = WinVideoPlayerController.file(midiaAtual)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
          _videoController?.setLooping(false);

          _timer = Timer(_videoController!.value.duration, _proximaMidia);
        }).catchError((error) {
          print('Erro ao inicializar o vídeo: $error');
        });
    } else {
      setState(() {});
      _timer = Timer(const Duration(seconds: 1), _proximaMidia);
    }
  }

  void _proximaMidia() {
    setState(() {
      _indiceAtual = (_indiceAtual + 1) % _midias.length;
    });
    _configurarMidiaAtual();
  }

  @override
  Widget build(BuildContext context) {
    final midiaAtual = _midias[_indiceAtual];

    return Scaffold(
      body: Center(
        child: midiaAtual.path.endsWith('.mp4')
            ? _videoController != null && _videoController!.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: WinVideoPlayer(_videoController!),
                    ),
                  )
                : const CircularProgressIndicator()
            : Image.file(
                midiaAtual,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
      ),
    );
  }
}
