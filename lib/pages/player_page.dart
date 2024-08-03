import 'package:flutter/material.dart';
import 'package:midia_player/models/media_view_model.dart';
import 'package:midia_player/widgets/image_widget.dart';
import 'package:midia_player/widgets/video_widget.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  MediaViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MediaViewModel();
    _viewModel!.setUpdateCallback(() {
      setState(() {});
    });
    if (_viewModel!.hasMidias) {
      _viewModel!.iniciarCicloMidias();
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel == null || !_viewModel!.hasMidias) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nenhuma mídia encontrada',
                style: TextStyle(color: Colors.black),
              ),
              Text('Caminho da pasta: "C:/mobi_player"'),
            ],
          ),
        ),
      );
    }

    final midiaAtual = _viewModel!.midias[_viewModel!.indiceAtual];

    return Scaffold(
      body: Center(
        child: midiaAtual.isVideo
            ? VideoWidget(
                videoPath: midiaAtual.file.path,
                onVideoEnd: () {
                  setState(() {
                    _viewModel!.onVideoEnd();
                  });
                },
              )
            : ImageWidget(imagePath: midiaAtual.file.path),
      ),
    );
  }
}
