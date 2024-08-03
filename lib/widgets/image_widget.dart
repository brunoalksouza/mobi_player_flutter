import 'dart:io';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
