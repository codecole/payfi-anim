import 'dart:html';

import 'package:flutter/material.dart';

class BuildAnimatedCylinder extends StatelessWidget {
  final int angleMultiplier;
  final Color boxColor;
  final String displayText;
  final Color textColor;
  final Color iconColor;
  final AnimationController controller;
  final Animation<double> angle;
  final Animation<double> containterSize;
  final Animation<double> opacity;
  final bool isOpened;
  BuildAnimatedCylinder({
    this.angle,
    this.angleMultiplier,
    this.boxColor,
    this.containterSize,
    this.controller,
    this.displayText,
    this.iconColor,
    this.opacity,
    this.textColor,
    this.isOpened,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      // child: ,
      builder: (context, child) {
        return Transform.rotate(
            // transform: Matrix4.skew(0, 0)..rotateZ(_angle.value),
            alignment: FractionalOffset.center,
            angle: angle.value * angleMultiplier,
            origin: Offset(-125, 0),
            child: Transform(
                transform:
                    Matrix4.diagonal3Values(containterSize.value, 1, 1.0),
                // origin: Offset(-125, 40),
                child: cylinder(250.0, boxColor, displayText, textColor,
                    iconColor, opacity, isOpened)));
      },
    );
  }
}

cylinder(height, color, text, Color textColor, Color iconColor,
    Animation<double> _opacity, var isOpened) {
  return SizedBox(
    height: 80,
    child: Stack(
      children: [
        Opacity(
          opacity: _opacity.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(53),
              color: color,
            ),
            width: height,
            height: 80.0,
          ),
        ),
        AnimatedPositioned(
          right: isOpened ? 10 : 100,
          top: 0,
          bottom: 0,
          duration: Duration(milliseconds: 500),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: isOpened ? 1 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 18),
                Icon(
                  Icons.arrow_right,
                  color: iconColor,
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}
