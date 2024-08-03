import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import '../env.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late List<String> _imagens;
  late int _indiceAtual;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _imagens = _carregarImagens();
    _indiceAtual = 0;
    _iniciarCicloImagens();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<String> _carregarImagens() {
    final dir = Directory(caminhoPasta);
    return dir
        .listSync()
        .where((item) => item is File && item.path.endsWith('.png'))
        .map((item) => item.path)
        .toList();
  }

  void _iniciarCicloImagens() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _indiceAtual = (_indiceAtual + 1) % _imagens.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _imagens.isNotEmpty
            ? Image.file(
                File(_imagens[_indiceAtual]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : const Text('Nenhuma imagem encontrada',
                style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
