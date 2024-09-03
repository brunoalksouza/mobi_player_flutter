import 'dart:io';
import 'package:flutter/material.dart';
import 'package:midia_player/controllers/player_controller.dart';
import 'package:midia_player/functions/show_error_dialog.dart';
import 'package:midia_player/widgets/image_widget.dart';
import 'package:midia_player/widgets/video_widget.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late PlayerController _controller;
  String? executavelPath;

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();
    _loadExecutavelPath();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadExecutavelPath() async {
    try {
      final file = File('C:/mobi_player/caminho_executavel.txt');
      executavelPath = await file.readAsString();
      executavelPath = executavelPath?.trim();
    } catch (e) {
      print('Erro ao ler o arquivo: $e');
    }
  }

  void _abrirExecutavel() {
    if (executavelPath != null && executavelPath!.isNotEmpty) {
      try {
        Process.run(executavelPath!, []).then((result) {
          if (result.exitCode != 0) {
            ShowErrorDialog(
              context,
              'Erro: ${result.exitCode}\n'
              'Saída do erro: ${result.stderr}',
            );
          }
        }).catchError((e) {
          ShowErrorDialog(
            context,
            'Erro ao abrir o caminho do executável, verifique se o caminho está correto:\n "$executavelPath"',
          );
        });
      } catch (e) {
        ShowErrorDialog(
          context,
          'Erro ao abrir executável: $e',
        );
      }
    } else {
      ShowErrorDialog(
        context,
        'Caminho do executável não encontrado. \n'
        'Verifique seu arquivo de texto em "C:/mobi_player/caminho_executavel.txt", ele está vazio ou não existe.',
      );
    }
  }

  Widget _body() {
    return ValueListenableBuilder<int>(
      valueListenable: _controller.midiaNotifier,
      builder: (context, value, child) {
        if (_controller.midias.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nenhuma mídia encontrada',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Adicione sua mídia em "C:/mobi_player"',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }
        final midiaAtual = _controller.midias[_controller.indiceAtual];
        return Center(
          child: midiaAtual.path.endsWith('.mp4')
              ? VideoWidget(
                  videoController: _controller.videoController!,
                  playerController: _controller,
                )
              : ImageWidget(
                  imagePath: midiaAtual.path,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _body(),
          Positioned.fill(
            child: GestureDetector(
              onTap: _abrirExecutavel,
            ),
          ),
        ],
      ),
    );
  }
}
