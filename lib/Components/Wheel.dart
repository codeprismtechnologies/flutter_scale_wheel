import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/physics.dart';

class Wheel extends StatefulWidget {
  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> with SingleTickerProviderStateMixin {
  double wheelSize = 350;
  double angle = 0;
  double radius;
  AnimationController ctrl;

  _WheelState() {
    radius = this.wheelSize / 2;
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController.unbounded(vsync: this);
    ctrl.addListener(() {
      double _angle = roundDouble(ctrl.value, 2);
      setState(() {
        angle = _angle >= 0 ? _angle : 0;
      });
    });
  }

  _panUpdateHandler(DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absolute change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // Total computed change
    double rotationalChange = verticalRotation + horizontalRotation;

    double _value = ctrl.value + (rotationalChange / 100);

    ctrl.value = _value > 0 ? _value : 0;
  }

  _panEndHandler(DragEndDetails d) {
    double _velocity = (d.velocity.pixelsPerSecond.dx / 100);
    ctrl.animateWith(FrictionSimulation(
        0.005, // <- the bigger this value, the less friction is applied
        ctrl.value,
        _velocity > 0 ? _velocity : 0 // <- Velocity of inertia
        ));
  }

  @override
  Widget build(BuildContext context) {
    WheelCircle wheelCircle = WheelCircle(
        wheelSize: wheelSize, longNeedleHeight: 30, shortNeedleHeight: 20);

    SizedBox wheelContainer = SizedBox(
      width: wheelSize,
      height: wheelSize,
      child: Container(
          color: Colors.transparent,
          // If scale doesnt respond to pan, change transparent to red an check.
          child: Center(child: CustomPaint(painter: wheelCircle))),
    );

    GestureDetector draggableWheel = GestureDetector(
      onPanUpdate: _panUpdateHandler,
      onPanEnd: _panEndHandler,
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (ctx, w) {
          return Center(
            child: Transform.rotate(
              angle: ctrl.value,
              child: AnimatedBuilder(
                animation: ctrl,
                builder: (ctx, w) {
                  angle = ctrl.value.roundToDouble();
                  return Center(
                    child: Transform.rotate(
                      angle: ctrl.value,
                      child: wheelContainer,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Center(
              child:
                  Text("Weight", style: Theme.of(context).textTheme.headline5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Center(
              child: Text(angle.toString(),
                  style: Theme.of(context).textTheme.headline4),
            ),
          ),
          draggableWheel
        ],
      ),
    );
  }
}

class WheelCircle extends CustomPainter {
  double wheelSize;
  double longNeedleHeight;
  double shortNeedleHeight;
  double radius;

  WheelCircle({this.wheelSize, this.longNeedleHeight, this.shortNeedleHeight}) {
    radius = wheelSize / 2;
  }

  getRadians(int angle) => angle * (pi / 180);

  @override
  void paint(Canvas canvas, Size size) {
    final wheelBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white;

    final shortNeedle = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white;

    final longNeedle = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white;

    canvas.drawCircle(Offset(0, 0), wheelSize / 2, wheelBorder);
    canvas.drawLine(Offset(0, -50), Offset(0, 0),
        wheelBorder); // <- this line is drawn just to help debug the angle. Comment this in prod.

    for (int i = 0; i <= 360; i++) {
      i % 5 == 0
          ? canvas.drawLine(
              Offset(radius * cos(getRadians(i)), radius * sin(getRadians(i))),
              Offset((radius - this.longNeedleHeight) * cos(getRadians(i)),
                  (radius - longNeedleHeight) * sin(getRadians(i))),
              longNeedle)
          : canvas.drawLine(
              Offset(radius * cos(getRadians(i)), radius * sin(getRadians(i))),
              Offset((radius - shortNeedleHeight) * cos(getRadians(i)),
                  (radius - shortNeedleHeight) * sin(getRadians(i))),
              shortNeedle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
