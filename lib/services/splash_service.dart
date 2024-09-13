import 'package:flutter/material.dart';
import 'package:midia_player/pages/player_page.dart';

abstract class NavigationService {
  void navigateToMain(BuildContext context);
}

class NavigationServiceImpl implements NavigationService {
  @override
  void navigateToMain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PlayerPage()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final NavigationService navigationService;

  const SplashScreen({super.key, required this.navigationService});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), () {
        widget.navigationService.navigateToMain(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color(0xFFE9E669),
          child: Image.asset(
            'lib/assets/logo_splash_screen.gif',
          ),
        ),
      ),
    );
  }
}
