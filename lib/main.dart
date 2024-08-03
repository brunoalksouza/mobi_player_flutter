import 'package:flutter/material.dart';
import 'package:midia_player/services/splash_service.dart';
// import 'package:midia_player/service/splash_service.dart'; // Comentado para remover SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Comentado o uso de SplashScreen e NavigationService
    return MaterialApp(
      home: SplashScreen(
        navigationService: NavigationServiceImpl(),
      ),
    );
  }
}
