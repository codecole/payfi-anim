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

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700))
          ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(-1.2, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _angle = Tween<double>(begin: 0, end: -45).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.12, 0.25, curve: Curves.ease),
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
      body: AnimatedBuilder(
        animation: _controller,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(53),
            color: Colors.green,
          ),
          width: 200.0,
          height: 70.0,
        ),
        builder: (context, child) {
          return Transform.rotate(
              alignment: Alignment.center,
              angle: _angle.value,
              origin: Offset(0, 0),
              child: child);
        },
      ),
    );
  }
}

class RoundedRectangle extends StatelessWidget {
  final double angle;
  final Color color;
  final double opacity;

  RoundedRectangle({this.angle, this.color, this.opacity});
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle ?? -45,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 900),
        opacity: opacity ?? 1.0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(53),
              color: color ?? Colors.green),
          width: 200.0,
          height: 70.0,
        ),
      ),
    );
  }
}
