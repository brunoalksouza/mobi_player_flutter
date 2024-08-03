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
_midias = _carregarMidias();
    _indiceAtual = 0;
    //add an if statemant to check if the midias list is not empty
    if (_midias.isNotEmpty) {
      _iniciarCicloMidias();
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_midias.isNotEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Nenhuma mídia encontrada',
              style: TextStyle(color: Colors.black)),
        ),
      );
    }

    final midiaAtual = _midias[_indiceAtual];


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
