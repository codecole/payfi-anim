import 'package:flutter/material.dart';
import 'dart:math';

class Anim extends StatefulWidget {
  @override
  State<Anim> createState() => _AnimState();
}

class _AnimState extends State<Anim> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool isStatic = true;
  Animation<double> _angle;
  Animation<double> _containterSize;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.5),
      end: Offset(-0.1, 0.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _angle = Tween<double>(begin: (pi * 5) / 180, end: pi / 4)
        .animate(CurvedAnimation(
            parent: _controller,
            // curve: Interval(0.12, 0.25, curve: Curves.ease),
            curve: Curves.ease));

    _containterSize = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(
      parent: _controller,
      // curve: Interval(0.12, 0.25, curve: Curves.ease),
      curve: Curves.ease,
    ));

    _opacity = Tween<double>(begin: 0.02, end: 1).animate(CurvedAnimation(
      parent: _controller,
      // curve: Interval(0.12, 0.25, curve: Curves.ease),
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Anim'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  buildAnimatedCylinder(
                    1,
                    Color(0xFF05F182),
                    // Colors.black),
                  ),
                  Positioned(
                      top: 25,
                      child: buildAnimatedCylinder(0, Color(0xff0815B3))),
                  Padding(
                    padding: EdgeInsets.only(top: 55),
                    child: buildAnimatedCylinder(-1, Color(0xFF05F182)),
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: Padding(
                      padding: EdgeInsets.only(left: 1.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isStatic = !isStatic;
                });
                isStatic ? _controller.forward() : _controller.reverse();
                // _controller.forward();
              },
              child: Text(isStatic ? 'Fire' : 'Return'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedCylinder(int angleMultiplier, Color boxColor) {
    return AnimatedBuilder(
      animation: _controller,
      // child: ,
      builder: (context, child) {
        return Transform.rotate(
            // transform: Matrix4.skew(0, 0)..rotateZ(_angle.value),
            alignment: FractionalOffset.center,
            angle: _angle.value * angleMultiplier,
            origin: Offset(-125, 0),
            child: Transform(
                transform:
                    Matrix4.diagonal3Values(_containterSize.value, 1, 1.0),
                // origin: Offset(-125, 40),
                child: cylinder(250.0, boxColor)));
      },
    );
  }

  Widget cylinder(height, color) {
    return Opacity(
      opacity: _opacity.value,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(53),
          color: color,
        ),
        width: height,
        height: 80.0,
      ),
    );
  }
}
