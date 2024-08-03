import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:midia_player/widgets/image_widget.dart';
import 'package:midia_player/widgets/video_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _midias = _carregarMidias();
    _indiceAtual = 0;
    if (_midias.isNotEmpty) {
      _iniciarCicloMidias();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<File> _carregarMidias() {
    final dir = Directory(caminhoPasta);
    return dir
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
  }

  void _iniciarCicloMidias() {
    _configurarMidiaAtual();
  }

  void _configurarMidiaAtual() {
    final midiaAtual = _midias[_indiceAtual];

    if (midiaAtual.path.endsWith('.mp4')) {
      _timer?.cancel();
      setState(() {});
    } else {
      setState(() {});
      _timer = Timer(const Duration(seconds: 15), _proximaMidia);
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

    if (!_midias.isNotEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Nenhuma mídia encontrada',
              style: TextStyle(color: Colors.black)),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: midiaAtual.path.endsWith('.mp4')
            ? VideoWidget(
                videoPath: midiaAtual.path,
                onVideoEnd: _proximaMidia,
              )
            : ImageWidget(
                imagePath: midiaAtual.path,
              ),
      ),
    );
  }
}
