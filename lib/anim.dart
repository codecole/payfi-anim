import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  var _dragPosition = Offset(0, 0);

  var dXLimit = 119.5;
  var dYLimit = 119.5;
  // var dyUpperLimit = 119.5;

  int selectedCylinderIndex;

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

    _angle = Tween<double>(begin: (math.pi * 5) / 180, end: math.pi / 4)
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
                  Transform.translate(
                    offset: _dragPosition,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Draggable(
                        dragAnchor: DragAnchor.pointer,
                        onDragEnd: (DraggableDetails details) {
                          var x = _dragPosition.dx;
                          var y = _dragPosition.dy;
                          if (x < 0) {
                            x = 0;
                            y = 0;
                          }

                          if (x > y) {
                            if (selectedCylinderIndex != 0) {
                              y = -x * selectedCylinderIndex;
                            }
                          } else {
                            x = -y * selectedCylinderIndex;
                          }

                          if (x > dXLimit / 2) {
                            x = dXLimit;
                          }
                          if (y > 0 && y > dYLimit / 2) {
                            y = dYLimit;
                          } else if (y < 0 && y < -dYLimit / 2) {
                            y = -dYLimit;
                          }

                          if (x <= dXLimit / 2) {
                            x = 0;
                            y = 0;
                          }
                          setState(() {
                            _dragPosition = Offset(x, y);
                          });
                          print(Offset(x, y));
                        },
                        onDragStarted: () {
                          print('hellp');
                        },

                        onDragUpdate: (DragUpdateDetails upd) {
                          if (selectedCylinderIndex == null) {
                            var hyp = math.sqrt((upd.delta.dx * upd.delta.dx) +
                                (upd.delta.dy * upd.delta.dy));
                            var sineAngle = (math.sin((math.pi * 90) / 180) *
                                    upd.delta.dx) /
                                hyp;
                            var angle = math.acos(sineAngle);
                            // print('angle');
                            // print(angle);
                            if (angle > 0.8) {
                              selectedCylinderIndex = upd.delta.dy < 0 ? 1 : -1;
                              dXLimit = 119.5;
                            } else {
                              selectedCylinderIndex = 0;
                              dXLimit = 180.5;
                            }
                            print(selectedCylinderIndex);
                          }

                          var x = _dragPosition.dx + upd.delta.dx;
                          var y = _dragPosition.dy + upd.delta.dy;

                          if (x < 0) {
                            x = 0;
                            y = 0;
                          }

                          if (x > y) {
                            if (selectedCylinderIndex != 0) {
                              y = -x * selectedCylinderIndex;
                            }
                          } else {
                            x = -y * selectedCylinderIndex;
                          }

                          if (x > (dXLimit)) {
                            x = dXLimit;
                          }

                          if (y > 0 && y > dYLimit) {
                            y = dYLimit;
                          } else if (y < 0 && y < -dYLimit) {
                            y = -dYLimit;
                          }
                          // if ((y * selectedCylinderIndex) > (dYLimit * selectedCylinderIndex)) {
                          //   y = dYLimit * selectedCylinderIndex;
                          // }
                          if (x <= 0) {
                            selectedCylinderIndex = null;
                          }

                          print(Offset(x, y));
                          setState(() {
                            _dragPosition = Offset(x, y);
                          });
                        },
                        feedback: SizedBox(),
                        child: Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 35.0,
                          ),
                        ),
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
        // child: Align(
        //   alignment: Alignment.centerRight,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: DragTarget(
        //       builder: (BuildContext context, List<Object> candidateData,
        //           List<dynamic> rejectedData) {
        //         return CircleAvatar(
        //           backgroundColor: Colors.yellow,
        //           radius: 35.0,
        //         );
        //       },
        //       onAccept: (obj) {
        //         print('accepted');
        //       },
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
