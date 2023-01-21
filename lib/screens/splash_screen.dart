import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   var colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];
    return Scaffold(
      body: Center(
        child: AnimatedTextKit(
  animatedTexts: [
    ColorizeAnimatedText(
      'LOADING....',
      colors: colorizeColors,
      textStyle: const TextStyle(
        fontSize: 32.0,
        fontFamily: 'Monoton',
        letterSpacing: 5
      ),
      speed: const Duration(milliseconds: 100),
    ),
  ],
  
  totalRepeatCount: 4,
  pause: const Duration(milliseconds: 1000),
  displayFullTextOnTap: true,
  stopPauseOnTap: true,
)
      ),
    );
  }
}