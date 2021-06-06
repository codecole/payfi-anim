import 'package:flutter/material.dart';
import 'dart:async';
import 'package:slide_to_act/slide_to_act.dart';

class AnimSample extends StatefulWidget {
  @override
  State<AnimSample> createState() => _AnimSampleState();
}

class _AnimSampleState extends State<AnimSample>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool isStatic = true;
  bool showText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(-1.2, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
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
      body: Stack(
        children: [
          AnimatedPositioned(
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 405),
              top: isStatic ? 298.0 : 260,
              right: isStatic ? 126.0 : 120,
              child: RoundedRectangle(
                sampleText: showText ? 'Sample text' : '',
                scale: isStatic ? 1 : 0.00,
                opacity: isStatic ? 1 : 0.0,
                angle: isStatic ? 120 : 0,
                color: Colors.blue,
              )),
          Positioned(
              top: 260.0,
              left: 60.0,
              child: RoundedRectangle(
                sampleText: showText ? 'Sample text' : '',
                scale: isStatic ? 1 : 0.05,
                angle: 0,
                opacity: isStatic ? 1 : 0.0,
                color: Colors.yellow,
              )),
          AnimatedPositioned(
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 405),
              top: isStatic ? 205.0 : 260,
              left: isStatic ? 30.0 : 40,
              child: RoundedRectangle(
                sampleText: showText ? 'Sample text' : '',
                angle: isStatic ? -45 : 0,
                opacity: isStatic ? 1 : 0.0,
                scale: isStatic ? 1 : 0.00,
              )),
          Center(
              child: SlideTransition(
            position: _offsetAnimation,
            child: GestureDetector(
              onHorizontalDragStart: (DragUpdateDetails) {
                print('we are here');
              },
              onHorizontalDragEnd: (DragUpdateDetails) {
                print(' no here');
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 30.0,
                ),
              ),
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isStatic = !isStatic;

                  showText = true;
                });
                isStatic ? _controller.forward() : _controller.reverse();
              },
              child: Text('Fire'),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedRectangle extends StatelessWidget {
  final Color color;

  final double angle;
  final double opacity;
  final double scale;
  final String sampleText;

  RoundedRectangle(
      {this.angle, this.color, this.opacity, this.scale, this.sampleText});
  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.skew(0.0, 0.0)
        ..rotateZ(angle ?? -45)
        ..scale(scale ?? 0.5),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 900),
        opacity: opacity ?? 0.5,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(53),
              color: color ?? Colors.green),
          width: 200.0,
          height: 70.0,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                sampleText ?? 'Sample Text',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.black, fontSize: 12.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
