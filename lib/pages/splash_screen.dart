import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocation_app/screens/map_screen.dart';

import '../screens/home_screen.dart';
import '../screens/bottom_navigation_bar.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Hide system UI (immersive mode)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Delay of 5 seconds before navigating to the next screen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => NavScreen())
      );
    });
  }

  @override
  void dispose() {
    // Restore system UI settings when the screen is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', ),
            const SizedBox(width:12.0),
            const Text(
              'LO.CO',
              style: TextStyle(fontSize: 35, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
