import 'package:flutter/material.dart';
import 'package:musicplayer/constants/colors.dart';

class IconButtons extends StatelessWidget {
  final dynamic icon;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final Color color;

  const IconButtons({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.height = 60,
    this.width = 50,
    this.color = whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(500, 150),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: onPressed,
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: icon is IconData
                ? Icon(
                    icon,
                    size: 40,
                    color: Colors.red,
                  )
                : Image.asset(
                    'assets/icons/google.png',
                    height: 30,
                    width: 30,
                  ),
          ),
        ),
      ),
    );
  }
}
