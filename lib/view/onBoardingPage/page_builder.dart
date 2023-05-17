import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musicplayer/constants/colors.dart';
import 'package:musicplayer/constants/text_style.dart';
import 'package:lottie/lottie.dart';

class OnBoardPageBuilder extends StatelessWidget {
  final Color color;
  final String lottieUrl;
  final String title;
  final String subtitle;

  const OnBoardPageBuilder({
    super.key,
    this.color = whiteColor,
    this.lottieUrl = '',
    this.title = '',
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              title,
              style: textStyle(
                  fontSize: 27, fontWeight: FontWeight.w700, color: blackColor),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: textStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: blackColor),
            ),
          ),
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset(
              lottieUrl,
              key: Key("${Random().nextInt(1000)}"),
              animate: true,
              frameRate: FrameRate(60),
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
