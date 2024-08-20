import 'package:flutter/material.dart';
import 'package:midia_player/controllers/player_controller.dart';
import 'package:midia_player/widgets/image_widget.dart';
import 'package:midia_player/widgets/video_widget.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late PlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
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
      ),
    );
  }
}
