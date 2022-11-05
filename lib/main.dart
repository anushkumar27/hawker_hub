import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hawker_hub/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'utilities/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        // Using Material Theme with Deep Purple Swatch
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xff6750a4),
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: 'lib/assets/logo.png',
        nextScreen: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text(Constants.appName)),
              backgroundColor: Constants.primarySurfaceColor,
            ),
            body: const HomeScreen()),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
      ),
    );
  }
}
