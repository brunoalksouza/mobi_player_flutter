import 'dart:io';
import 'package:midia_player/functions/show_error_dialog.dart';

// ignore: non_constant_identifier_names
Future<String?> CarregarExecutavelPath() async {
  try {
    final file = File('C:/mobi_player/caminho_executavel.txt');
    String executavelPath = await file.readAsString();
    return executavelPath.trim();
  } catch (e) {
    print('Erro ao ler o arquivo: $e');
    return null;
  }
}

// ignore: non_constant_identifier_names
void AbrirExecutavel(context, String? executavelPath) {
  if (executavelPath != null && executavelPath.isNotEmpty) {
    try {
      Process.run(executavelPath, ['--kiosk']).then((result) {
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
