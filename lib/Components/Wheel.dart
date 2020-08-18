import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/physics.dart';

class Wheel extends StatefulWidget {
  final double wheelSize;

  Wheel({@required this.wheelSize});

  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> with SingleTickerProviderStateMixin {
  double wheelSize;
  double angle = 0;
  double radius;
  AnimationController ctrl;

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double roundToFifthDecimal(double num) {
    double decimal = num - num.toInt();
    int number = num.toInt();

    return decimal == .5
        ? num
        : decimal < .25
            ? number.toDouble()
            : decimal >= .25 && decimal < .75
                ? number + .5
                : (number + 1).toDouble();
  }

  @override
  void initState() {
    wheelSize = widget.wheelSize;
    radius = this.wheelSize / 2;
    ctrl = AnimationController.unbounded(vsync: this);
    ctrl.addListener(() {
      double _angle = roundDouble(ctrl.value  - ((ctrl.value.toInt() / 2) * 0.1), 1);
      print(_angle);
      setState(() {
        angle = _angle >= 0 ? ctrl.value.toInt().toDouble() : 0;
      });
    });
    super.initState();
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
//    ctrl.animateWith(FrictionSimulation(
//        0.005, // <- the bigger this value, the less friction is applied
//        ctrl.value,
//        d.velocity.pixelsPerSecond.dx / 100 // <- Velocity of inertia
//        ));

//    ctrl.animateTo(roundToFifthDecimal(roundDouble(ctrl.value, 2) * 2), duration: Duration(milliseconds: 500));

//    print(
//        "Decimal: ${roundDouble(ctrl.value * 1.5, 2)}, roundedTo5: ${roundToFifthDecimal(roundDouble(ctrl.value, 2) * 2)}");
  }

  @override
  Widget build(BuildContext context) {
    WheelCircle wheelCircle = WheelCircle(
        wheelSize: wheelSize, longNeedleHeight: 40, shortNeedleHeight: 25);

    Container wheelContainer = Container(
      width: wheelSize,
      height: wheelSize,
      color: Colors.transparent,
      // If scale doesnt respond to pan, change transparent to red an check.
      child: Center(child: CustomPaint(painter: wheelCircle)),
    );

    GestureDetector draggableWheel = GestureDetector(
      onPanUpdate: _panUpdateHandler,
      onPanEnd: _panEndHandler,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: ctrl,
            builder: (ctx, w) {
              angle = ctrl.value.roundToDouble();
              return Transform.rotate(
                angle: ctrl.value,
                child: wheelContainer,
              );
            },
          ),
          Container(
              width: wheelSize,
              height: wheelSize,
              child: CustomPaint(
                painter: WheelDecoration(),
              ))
        ],
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
          SizedBox(
            width: wheelSize,
            height: wheelSize,
            child: ClipRRect(
              child: draggableWheel,
              clipper: SemiCircleClip(),
            ),
          )
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

//    canvas.drawCircle(Offset(0, 0), wheelSize / 2, wheelBorder);
//    canvas.drawLine(Offset(0, -50), Offset(0, 0),
//        wheelBorder); // <- this line is drawn just to help debug the angle. Comment this in prod.

    for (int i = 0; i <= 360; i++) {
      if (i % 6 == 0) {
        i % 60 == 0
            ? canvas.drawLine(
                Offset(
                    radius * cos(getRadians(i)), radius * sin(getRadians(i))),
                Offset((radius - (longNeedleHeight * .75)) * cos(getRadians(i)),
                    (radius - (longNeedleHeight * .75)) * sin(getRadians(i))),
                longNeedle)
            : i % 30 == 0
                ? canvas.drawLine(
                    Offset(radius * cos(getRadians(i)),
                        radius * sin(getRadians(i))),
                    Offset((radius - longNeedleHeight) * cos(getRadians(i)),
                        (radius - longNeedleHeight) * sin(getRadians(i))),
                    longNeedle)
                : canvas.drawLine(
                    Offset(radius * cos(getRadians(i)),
                        radius * sin(getRadians(i))),
                    Offset((radius - shortNeedleHeight) * cos(getRadians(i)),
                        (radius - shortNeedleHeight) * sin(getRadians(i))),
                    shortNeedle);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WheelDecoration extends CustomPainter {
  final indicator = Paint()
    ..color = Color(0xFF007CFA)
    ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect leftRect = Rect.fromLTRB(0, 0, size.width * .3, size.height);

    final Rect rightRect =
        Rect.fromLTRB(size.width * .7, 0, size.width, size.height);

    final Paint leftRectStyle = Paint()
      ..shader = LinearGradient(
        colors: <Color>[
          Color(0xFF303030).withOpacity(1),
          Color(0xFF303030).withOpacity(.95),
          Color(0xFF303030).withOpacity(0)
        ],
      ).createShader(leftRect);

    final Paint rightRectStyle = Paint()
      ..shader = LinearGradient(
        colors: <Color>[
          Color(0xFF303030).withOpacity(0),
          Color(0xFF303030).withOpacity(.95),
          Color(0xFF303030).withOpacity(1)
        ],
      ).createShader(rightRect);
//    ..color = Colors.red;

    canvas.drawCircle(Offset(size.width * .5, -10), 5, indicator);
    canvas.drawLine(
        Offset(size.width * .5, -10), Offset(size.width * .5, 60), indicator);
    canvas.drawRect(leftRect, leftRectStyle);
    canvas.drawRect(rightRect, rightRectStyle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SemiCircleClip extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    return RRect.fromLTRBR(
        0, -25, size.width, size.height / 2, Radius.circular(5));
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
