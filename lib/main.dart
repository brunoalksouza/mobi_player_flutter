import 'package:flutter/material.dart';
import 'package:midia_player/services/splash_service.dart';
 
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
