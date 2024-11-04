import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../constants/styles.dart';

class AnimatedTitle extends StatelessWidget {
  final double fontSize;

  const AnimatedTitle({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          "CyberGuard",
          textStyle: AppTextStyles.animatedTextStyle(fontSize),
          speed: const Duration(milliseconds: 100),
        ),
      ],
      totalRepeatCount: 9999999,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
    );
  }
}
