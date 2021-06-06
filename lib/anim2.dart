import 'dart:math';

import 'package:flutter/material.dart';

class Trial2 extends StatefulWidget {
  @override
  _Trial2State createState() => _Trial2State();
}

class _Trial2State extends State<Trial2> with SingleTickerProviderStateMixin {
  bool isDone = false;
  AnimationController _animationController;
  Animation<double> _circleSize;
  Animation<Offset> _circlePosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    final size = MediaQuery.of(context).size;
    _circleSize = Tween<double>(begin: size.width / 2, end: size.width / 6)
        .animate(curvedAnimation);
    _circlePosition = Tween<Offset>(
      begin: Offset(size.width / 4, size.height / 2 - 70),
      end: Offset(size.width / 1.65, size.height / 2 - 10),
    ).animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            CustomContainer(
              color: Colors.greenAccent,
              angle: 45,
              voidCallback: () {
                print('1');
              },
              position:
                  Offset(size.width / 5, size.height / 2 + size.height * 0.1),
              animation: _circleSize,
              delay: 1200,
            ),
            CustomContainer(
              color: Colors.blue,
              angle: 0,
              voidCallback: () {
                print('2');
              },
              position: Offset(size.width / 4, size.height / 2),
              animation: _circleSize,
              delay: 800,
            ),
            CustomContainer(
              color: Colors.greenAccent,
              angle: 135,
              voidCallback: () {
                print('3');
              },
              position:
                  Offset(size.width / 5, size.height / 2 - size.height * 0.1),
              animation: _circleSize,
              delay: 400,
            ),
            AnimatedBuilder(
                animation: _circlePosition,
                builder: (context, child) {
                  return Positioned(
                    top: _circlePosition.value.dy,
                    right: _circlePosition.value.dx,
                    child: AnimatedBuilder(
                      animation: _circleSize,
                      builder: (context, child) {
                        return Container(
                          width: _circleSize.value,
                          height: _circleSize.value,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(3, 3),
                                blurRadius: 10,
                                spreadRadius: 1,
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.1),
                              ),
                              BoxShadow(
                                offset: Offset(-3, -3),
                                blurRadius: 10,
                                spreadRadius: 1,
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  isDone
                      ? _animationController.reverse()
                      : _animationController.forward();
                  setState(() {
                    isDone = !isDone;
                  });
                },
                child: Text(isDone ? 'Reverse' : 'start'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

typedef VoidCallback = void Function();

class CustomContainer extends StatelessWidget {
  final Color color;
  final double angle;
  final int delay;
  final Offset position;
  final VoidCallback voidCallback;
  final Animation<double> animation;

  CustomContainer({
    this.color,
    this.angle,
    this.delay,
    this.position,
    this.animation,
    this.voidCallback,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return Positioned(
          top: position.dy,
          left: position.dx,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(-30 / 2, -30 / 2, 0.0)
              ..rotateZ(2 * pi * (angle / 360)),
            child: Visibility(
              visible: animation.isCompleted,
              child: FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 20)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return InkWell(
                        onTap: voidCallback,
                        child: Container(
                          height: size.height * 0.1,
                          width: size.width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: color,
                          ),
                        ),
                      );
                    }
                    //return GestureDetector();
                    return SizedBox.shrink();
                  }),
            ),
          ),
        );
      },
    );
  }
}
