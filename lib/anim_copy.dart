import 'package:flutter/material.dart';
import 'dart:math' as math;

class Anim2 extends StatefulWidget {
  @override
  State<Anim2> createState() => _Anim2State();
}

class _Anim2State extends State<Anim2> with SingleTickerProviderStateMixin {
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

  var isOpened = false;

  Future<Object> goToPage() {
    var text = '';
    switch (selectedCylinderIndex) {
      case 1:
        {
          text = 'Sample 2';
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DemoPage1()))
              .then((value) => setState(() {
                    _dragPosition = Offset(0, 0);
                  }));

          break;
        }
      case 0:
        {
          text = 'Sample 3';
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DemoPage2()))
              .then((value) => setState(() {
                    _dragPosition = Offset(0, 0);
                  }));

          break;
        }
      case -1:
        {
          text = 'Sample';
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DemoPage(
                        title: text,
                      ))).then((value) => setState(() {
                _dragPosition = Offset(0, 0);
              }));

          break;
        }
      default:
        break;
    }
    return null;

    // return Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
    //   return DemoPage2();
    // })).then((value) {
    //   setState(() {
    //     _dragPosition = Offset(0, 0);
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                isOpened = true;
              });
            } else if (status == AnimationStatus.dismissed) {
              setState(() {
                isOpened = false;
              });
            }
          });

    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.44),
      end: Offset(-0.1, 0.44),
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

    _opacity = Tween<double>(begin: 0.05, end: 1).animate(CurvedAnimation(
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
    List<Widget> stackChildren = <Widget>[
      buildAnimatedCylinder(
          1, Color(0xFF05F182), 'Sample', Colors.black, Colors.pink),
      Positioned(
          top: 25,
          child: buildAnimatedCylinder(
              0, Color(0xff0815B3), 'Sample 3', Colors.red, Colors.yellow)),
      Padding(
        padding: EdgeInsets.only(top: 55),
        child: buildAnimatedCylinder(
            -1, Color(0xFF05F182), 'Sample 2', Colors.purple, Colors.red),
      ),
    ];

    void reArrange() {
      setState(() {
        stackChildren = <Widget>[
          Positioned(
              top: 25,
              child: buildAnimatedCylinder(
                  0, Color(0xff0815B3), 'Sample 3', Colors.red, Colors.yellow)),
          buildAnimatedCylinder(
              1, Color(0xFF05F182), 'Sample', Colors.black, Colors.pink),
          Padding(
            padding: EdgeInsets.only(top: 55),
            child: buildAnimatedCylinder(
                -1, Color(0xFF05F182), 'Sample 2', Colors.purple, Colors.red),
          ),
        ];
      });
    }

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
                  Stack(
                    children: stackChildren,
                  ),
                  Transform.translate(
                    offset: _dragPosition,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Draggable<int>(
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
                            x = -y * (selectedCylinderIndex ?? 0);
                          }

                          if (x > dXLimit / 2) {
                            x = dXLimit;
                            goToPage();
                          }
                          if (y > 0 && y > dYLimit / 2) {
                            y = dYLimit;
                          } else if (y < 0 && y < -dYLimit / 2) {
                            y = -dYLimit;
                          }

                          if (x <= dXLimit / 2) {
                            x = 0;
                            y = 0;
                            selectedCylinderIndex = null;
                          }
                          setState(() {
                            _dragPosition = Offset(x, y);
                          });
                        },
                        onDragStarted: () {},
                        onDragUpdate: (DragUpdateDetails upd) {
                          if (selectedCylinderIndex == null) {
                            var hyp = math.sqrt((upd.delta.dx * upd.delta.dx) +
                                (upd.delta.dy * upd.delta.dy));
                            var sineAngle = (math.sin((math.pi * 90) / 180) *
                                    upd.delta.dx) /
                                hyp;
                            var angle = math.acos(sineAngle);
                            print(angle);
                            if (angle > 0.2) {
                              selectedCylinderIndex = upd.delta.dy < 0 ? 1 : -1;
                              dXLimit = 119.5;
                            } else {
                              selectedCylinderIndex = 0;

                              dXLimit = 180.5;
                            }
                          } else {
                            print(selectedCylinderIndex);
                          }

                          var x = _dragPosition.dx + upd.delta.dx;
                          var y = _dragPosition.dy + upd.delta.dy;

                          if (x < 0) {
                            x = 0;
                            y = 0;
                          }

                          if (y > 0 && y > dYLimit) {
                            y = dYLimit;
                          } else if (y < 0 && y < -dYLimit) {
                            y = -dYLimit;
                          }

                          if (x > y) {
                            if (selectedCylinderIndex != 0) {
                              y = -x * selectedCylinderIndex;
                            }
                          } else {
                            x = -y * selectedCylinderIndex;
                          }
                          if (selectedCylinderIndex == 0) {
                            y = 0;
                          }

                          if (x > (dXLimit)) {
                            x = dXLimit;
                          }
                          if (x <= 0) {
                            selectedCylinderIndex = null;
                          }
                          setState(() {
                            _dragPosition = Offset(x, y);
                          });
                        },
                        feedback: SizedBox(),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.ac_unit_rounded),
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

  Widget buildAnimatedCylinder(int angleMultiplier, Color boxColor,
      String displayText, Color textColor, Color iconColor) {
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
                child: cylinder(
                    250.0, boxColor, displayText, textColor, iconColor)));
      },
    );
  }

  Widget cylinder(height, color, text, Color textColor, Color iconColor) {
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
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
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
}

class DemoPage extends StatelessWidget {
  final String title;
  DemoPage({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: Text(title)),
    );
  }
}

class DemoPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Its number 2'),
      ),
      body: Center(child: Text('number 2')),
    );
  }
}

class DemoPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("number3"),
      ),
      body: Center(child: Text(" I amnumber 3")),
    );
  }
}
