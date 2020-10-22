import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

enum NeedlesDirection { ltr, rtl, ttb, btt, ttbc, bttc, ltrc, rtlc }
enum ScaleBase { base1, base12, base10, base100 }
enum ScaleMeasurePoint { start, center, end }
enum _needleType { long, median, short }

class NeedleIndents {
  final double indent;
  final double endIndent;

  NeedleIndents({this.indent, this.endIndent});
}

class ScaleBar extends StatefulWidget {
  final double width;
  final double height;
  final bool horizontal;
  final Color backgroundColor;
  final Color shortNeedleColor;
  final Color longNeedleColor;
  final Function(double scaleValue, double scaleDistance) onValueChange;
  final bool showCenterIndicator;
  final NeedlesDirection needlesDirection;
  final double gapBetweenNeedles;
  final double longNeedleThickness;
  final double shortNeedleThickness;
  final ScaleBase scaleBase;
  final int scaleBaseTimes;
  final bool showMedianNeedles;
  final bool showScaleNumbers;
  final TextStyle numberTextStyle;
  final Widget indicator;
  final bool showIndicator;
  final ScaleMeasurePoint measurePoint;
  final bool fadedEdges;
  final double initialScaleValue;
  final double scaleFriction;

  ScaleBar(
      {@required this.width,
      @required this.height,
      this.onValueChange,
      this.shortNeedleColor = Colors.blueGrey,
      this.longNeedleColor = Colors.blueGrey,
      this.horizontal = false,
      this.backgroundColor = Colors.white,
      this.showCenterIndicator = true,
      this.needlesDirection = NeedlesDirection.ltr,
      this.gapBetweenNeedles = 10,
      this.longNeedleThickness = 2,
      this.shortNeedleThickness = 1,
      this.scaleBase = ScaleBase.base10,
      this.scaleBaseTimes = 10,
      this.showMedianNeedles = true,
      this.showScaleNumbers = true,
      this.numberTextStyle,
      this.indicator,
      this.showIndicator = true,
      this.measurePoint = ScaleMeasurePoint.center,
      this.fadedEdges = true,
      this.initialScaleValue = 0,
      this.scaleFriction = 1})
      : assert(width != null),
        assert(height != null),
        assert(scaleFriction > 0 && scaleFriction <= 1);

  @override
  _ScaleBarState createState() => _ScaleBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('indicator', indicator));
  }
}

class _ScaleBarState extends State<ScaleBar>
    with SingleTickerProviderStateMixin {
  final double numberSpace = 20;
  final double numberWidth = 50;
  ScrollController ctrl = ScrollController();
  int _baseInt = 10;
  double scaleWidth = 0;
  double scaleHeight = 0;
  double paddingLeft = 0;
  double paddingTop = 0;
  double paddingRight = 0;
  double paddingBottom = 0;
  ScrollPhysics _scrollPhysics;

  @override
  void initState() {
    ctrl.addListener(
      () {
        if (widget.onValueChange != null)
          widget.onValueChange(
              double.parse(_parseDistanceToScaleValue(ctrl.position.pixels)
                  .toStringAsFixed(2)),
              double.parse(_parseScaleValueToDistance(double.parse(
                      _parseDistanceToScaleValue(ctrl.position.pixels)
                          .toStringAsFixed(2)))
                  .toStringAsFixed(2)));
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ctrl.jumpTo(_parseScaleValueToDistance(widget.initialScaleValue));
    });
    _scrollPhysics = ScalePhysics(scaleFriction: widget.scaleFriction);
    super.initState();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ScaleBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialScaleValue != widget.initialScaleValue) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ctrl.animateTo(_parseScaleValueToDistance(widget.initialScaleValue),
            duration: Duration(milliseconds: 351),
            curve: Curves.easeInToLinear);
      });
    }
    if (oldWidget.scaleFriction != widget.scaleFriction) {
      setState(() {
        _scrollPhysics = BouncingScrollPhysics();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _scrollPhysics = ScalePhysics(scaleFriction: widget.scaleFriction);
          });
        });
      });
    }
  }

  _setScalePadding() {
    if (widget.horizontal) {
      paddingLeft = widget.measurePoint == ScaleMeasurePoint.end
          ? widget.width
          : widget.measurePoint == ScaleMeasurePoint.center
              ? widget.width / 2.075
              : 0;
      paddingRight = widget.measurePoint == ScaleMeasurePoint.end
          ? 0
          : widget.measurePoint == ScaleMeasurePoint.center
              ? widget.width / 1.93
              : widget.width;
      paddingTop = 0;
      paddingBottom = 0;
    } else {
      paddingTop = widget.measurePoint == ScaleMeasurePoint.end
          ? widget.height
          : widget.measurePoint == ScaleMeasurePoint.center
              ? widget.height / 2.075
              : 0;
      paddingBottom = widget.measurePoint == ScaleMeasurePoint.end
          ? 0
          : widget.measurePoint == ScaleMeasurePoint.center
              ? widget.height / 1.93
              : widget.height;
      paddingLeft = 0;
      paddingRight = 0;
    }
  }

  _setScaleDimensions() {
    scaleWidth = (widget.horizontal
            ? _numberOfNeedles() * widget.gapBetweenNeedles
            : widget.showScaleNumbers
                ? widget.width + numberSpace
                : widget.width) +
        paddingLeft +
        paddingRight;
    scaleHeight = (widget.horizontal
            ? widget.showScaleNumbers
                ? widget.height + numberSpace
                : widget.height
            : _numberOfNeedles() * widget.gapBetweenNeedles) +
        paddingTop +
        paddingBottom;
  }

  _setBaseInt() {
    switch (widget.scaleBase) {
      case ScaleBase.base1:
        _baseInt = 1;
        break;
      case ScaleBase.base12:
        _baseInt = 12;
        break;
      case ScaleBase.base10:
        _baseInt = 10;
        break;
      case ScaleBase.base100:
        _baseInt = 100;
        break;
    }
  }

  int _parseIndexToScaleNumber(int index) {
    switch (widget.scaleBase) {
      case ScaleBase.base1:
        return index ~/ 10;
      case ScaleBase.base100:
        return index * 10;
      case ScaleBase.base12:
        return index ~/ 12;
      case ScaleBase.base10:
      default:
        return index;
    }
  }

  _numberOfNeedles() => widget.scaleBase == ScaleBase.base12
      ? 12 * widget.scaleBaseTimes
      : 10 * widget.scaleBaseTimes;

  _needleType _getNeedleType(int index) {
    if (widget.scaleBase == ScaleBase.base12) {
      if (widget.showMedianNeedles) {
        return index % _baseInt == 0
            ? _needleType.long
            : index % (_baseInt / 2) == 0
                ? _needleType.median
                : _needleType.short;
      } else {
        return index % _baseInt == 0 ? _needleType.long : _needleType.median;
      }
    } else {
      if (widget.showMedianNeedles) {
        return index % 10 == 0
            ? _needleType.long
            : index % 5 == 0
                ? _needleType.median
                : _needleType.short;
      } else {
        return index % 10 == 0 ? _needleType.long : _needleType.median;
      }
    }
  }

  double _parseDistanceToScaleValue(double pixelDistance) {
    double _pixelDistance = pixelDistance.abs();
    switch (widget.scaleBase) {
      case ScaleBase.base1:
        _pixelDistance = _pixelDistance / 100;
        break;
      case ScaleBase.base12:
        _pixelDistance = _pixelDistance / 120;
        break;
      case ScaleBase.base10:
        _pixelDistance = _pixelDistance / 10;
        break;
      case ScaleBase.base100:
      default:
        _pixelDistance = _pixelDistance;
        break;
    }
    return _pixelDistance / (widget.gapBetweenNeedles / 10);
  }

  double _parseScaleValueToDistance(double scaleValue) {
    double _distance = 0;
    switch (widget.scaleBase) {
      case ScaleBase.base1:
        _distance = scaleValue * 100;
        break;
      case ScaleBase.base12:
        _distance = scaleValue * 120;
        break;
      case ScaleBase.base10:
        _distance = scaleValue * 10;
        break;
      case ScaleBase.base100:
      default:
        _distance = ctrl.position.pixels;
        break;
    }
    return _distance * (widget.gapBetweenNeedles / 10);
  }

  Widget _horizontalScaleBuilder() {
    NeedleIndents longNeedleIndents() {
      if (widget.needlesDirection == NeedlesDirection.bttc ||
          widget.needlesDirection == NeedlesDirection.ttbc) {
        return NeedleIndents(
            indent: widget.height * .1, endIndent: widget.height * .1);
      } else {
        return NeedleIndents(
            indent: widget.needlesDirection == NeedlesDirection.ttb
                ? 0
                : widget.height * .25,
            endIndent: widget.needlesDirection == NeedlesDirection.ttb
                ? widget.height * .25
                : 0);
      }
    }

    NeedleIndents medianNeedleIndents() {
      if (widget.needlesDirection == NeedlesDirection.bttc ||
          widget.needlesDirection == NeedlesDirection.ttbc) {
        return NeedleIndents(
            indent: widget.height * .2, endIndent: widget.height * .2);
      } else {
        return NeedleIndents(
            indent: widget.needlesDirection == NeedlesDirection.ttb
                ? 0
                : widget.height * .5,
            endIndent: widget.needlesDirection == NeedlesDirection.ttb
                ? widget.height * .5
                : 0);
      }
    }

    NeedleIndents shortNeedleIndents() {
      if (widget.needlesDirection == NeedlesDirection.bttc ||
          widget.needlesDirection == NeedlesDirection.ttbc) {
        return NeedleIndents(
            indent: widget.height * .3, endIndent: widget.height * .3);
      } else {
        return NeedleIndents(
            indent: widget.needlesDirection == NeedlesDirection.ttb
                ? 0
                : widget.height * .65,
            endIndent: widget.needlesDirection == NeedlesDirection.ttb
                ? widget.height * .65
                : 0);
      }
    }

    final VerticalDivider longNeedle = VerticalDivider(
      width: widget.gapBetweenNeedles,
      thickness: widget.longNeedleThickness,
      color: widget.longNeedleColor,
      indent: longNeedleIndents().indent,
      endIndent: longNeedleIndents().endIndent,
    );

    final VerticalDivider medianNeedle = VerticalDivider(
      width: widget.gapBetweenNeedles,
      thickness: widget.shortNeedleThickness,
      color: widget.shortNeedleColor,
      indent: medianNeedleIndents().indent,
      endIndent: medianNeedleIndents().endIndent,
    );

    final VerticalDivider shortNeedle = VerticalDivider(
      width: widget.gapBetweenNeedles,
      thickness: widget.shortNeedleThickness,
      color: widget.shortNeedleColor,
      indent: shortNeedleIndents().indent,
      endIndent: shortNeedleIndents().endIndent,
    );

    final List<Widget> needleTrack =
        List(_numberOfNeedles()).asMap().entries.map((entry) {
      switch (_getNeedleType(entry.key)) {
        case _needleType.long:
          return longNeedle;
        case _needleType.median:
          return medianNeedle;
        case _needleType.short:
          return shortNeedle;
      }
    }).toList(growable: false);

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.showScaleNumbers
            ? Positioned(
                width: _numberOfNeedles() * widget.gapBetweenNeedles,
                height: numberSpace,
                left: -(numberWidth / 2),
                top: (widget.needlesDirection == NeedlesDirection.ttb ||
                        widget.needlesDirection == NeedlesDirection.ttbc)
                    ? widget.height
                    : 0,
                child: Row(children: _numbersList()))
            : Container(),
        Positioned(
            width: _numberOfNeedles() * widget.gapBetweenNeedles,
            height: widget.height,
            top: widget.showScaleNumbers
                ? (widget.needlesDirection == NeedlesDirection.ttb ||
                        widget.needlesDirection == NeedlesDirection.ttbc)
                    ? 0
                    : numberSpace
                : 0,
            left: 0,
            child: Row(
              children: needleTrack,
            ))
      ],
    );
  }

  List<Widget> _numbersList() =>
      List(_numberOfNeedles()).asMap().entries.map((entry) {
        if (_getNeedleType(entry.key) == _needleType.long) {
          return RotatedBox(
            quarterTurns: widget.horizontal ? 0 : 1,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: widget.gapBetweenNeedles < numberWidth
                      ? widget.gapBetweenNeedles
                      : numberWidth - widget.gapBetweenNeedles),
              width: numberWidth,
              height: numberSpace,
              child: Text(_parseIndexToScaleNumber(entry.key).toString(),
                  maxLines: 2),
            ),
          );
        } else {
          final double gapBetweenLongNeedles =
              widget.scaleBase == ScaleBase.base12
                  ? widget.gapBetweenNeedles * 12
                  : widget.gapBetweenNeedles * 10;
          return RotatedBox(
            quarterTurns: widget.horizontal ? 0 : 1,
            child: Container(
                width: (gapBetweenLongNeedles - numberWidth) /
                    (widget.scaleBase == ScaleBase.base12 ? 11 : 9),
                height: numberSpace),
          );
        }
      }).toList(growable: false);

  Stack _verticalScaleBuilder() {
    // For Vertical Scale
    NeedleIndents longNeedleIndents() {
      if (widget.needlesDirection == NeedlesDirection.rtlc ||
          widget.needlesDirection == NeedlesDirection.ltrc) {
        return NeedleIndents(
            indent: widget.width * .15, endIndent: widget.width * .15);
      } else {
        return NeedleIndents(
            indent: widget.needlesDirection == NeedlesDirection.ltr
                ? 0
                : widget.width * .25,
            endIndent: widget.needlesDirection == NeedlesDirection.ltr
                ? widget.width * .25
                : 0);
      }
    }

    NeedleIndents medianNeedleIndents() {
      if (widget.needlesDirection == NeedlesDirection.rtlc ||
          widget.needlesDirection == NeedlesDirection.ltrc) {
        return NeedleIndents(
            indent: widget.width * .25, endIndent: widget.width * .25);
      } else {
        return NeedleIndents(
            indent: widget.needlesDirection == NeedlesDirection.ltr
                ? 0
                : widget.width * .5,
            endIndent: widget.needlesDirection == NeedlesDirection.ltr
                ? widget.width * .5
                : 0);
      }
    }

    NeedleIndents shortNeedleIndents() {
      if (widget.needlesDirection == NeedlesDirection.rtlc ||
          widget.needlesDirection == NeedlesDirection.ltrc) {
        return NeedleIndents(
            indent: widget.width * .35, endIndent: widget.width * .35);
      } else {
        return NeedleIndents(
            indent: widget.needlesDirection == NeedlesDirection.ltr
                ? 0
                : widget.width * .65,
            endIndent: widget.needlesDirection == NeedlesDirection.ltr
                ? widget.width * .65
                : 0);
      }
    }

    final Divider longNeedle = Divider(
      height: widget.gapBetweenNeedles,
      thickness: widget.longNeedleThickness,
      color: widget.longNeedleColor,
      indent: longNeedleIndents().indent,
      endIndent: longNeedleIndents().endIndent,
    );

    final Divider medianNeedle = Divider(
      height: widget.gapBetweenNeedles,
      thickness: widget.shortNeedleThickness,
      color: widget.shortNeedleColor,
      indent: medianNeedleIndents().indent,
      endIndent: medianNeedleIndents().endIndent,
    );

    final Divider shortNeedle = Divider(
      height: widget.gapBetweenNeedles,
      thickness: widget.shortNeedleThickness,
      color: widget.shortNeedleColor,
      indent: shortNeedleIndents().indent,
      endIndent: shortNeedleIndents().endIndent,
    );

    final List<Widget> needleTrack =
        List(_numberOfNeedles()).asMap().entries.map((entry) {
      switch (_getNeedleType(entry.key)) {
        case _needleType.long:
          return longNeedle;
        case _needleType.median:
          return medianNeedle;
        case _needleType.short:
          return shortNeedle;
      }
    }).toList(growable: false);

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.showScaleNumbers
            ? Positioned(
                width: numberSpace,
                height: _numberOfNeedles() * widget.gapBetweenNeedles,
                left: (widget.needlesDirection == NeedlesDirection.ltr ||
                        widget.needlesDirection == NeedlesDirection.ltrc)
                    ? widget.width - numberSpace
                    : 0,
                top: -numberSpace,
                child: Column(children: _numbersList()))
            : Container(),
        Positioned(
            width: widget.width,
            height: _numberOfNeedles() * widget.gapBetweenNeedles,
            top: 5,
            left: 0,
            child: Column(
              children: needleTrack,
            ))
      ],
    );
  }

  Widget scaleIndicator() => widget.showIndicator
      ? Container(
          width: widget.horizontal
              ? widget.width
              : widget.showScaleNumbers
                  ? widget.width + numberSpace
                  : widget.width,
          height: widget.horizontal
              ? widget.showScaleNumbers
                  ? widget.height + numberSpace
                  : widget.height
              : widget.height,
          alignment: widget.horizontal
              ? widget.measurePoint == ScaleMeasurePoint.center
                  ? Alignment.center
                  : widget.measurePoint == ScaleMeasurePoint.end
                      ? Alignment.centerRight
                      : Alignment.centerLeft
              : widget.measurePoint == ScaleMeasurePoint.center
                  ? Alignment.center
                  : widget.measurePoint == ScaleMeasurePoint.end
                      ? Alignment.bottomCenter
                      : Alignment.topCenter,
          child: RotatedBox(
            quarterTurns: widget.horizontal ? 0 : 1,
            child: widget.indicator ??
                ScaleBarIndicator(
                    horizontal: widget.horizontal,
                    scaleWidth: scaleWidth,
                    scaleHeight: scaleHeight),
          ),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    _setBaseInt();
    _setScalePadding();
    _setScaleDimensions();
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return widget.fadedEdges
                ? LinearGradient(
                    begin: widget.horizontal
                        ? Alignment.centerLeft
                        : Alignment.topCenter,
                    end: widget.horizontal
                        ? Alignment.centerRight
                        : Alignment.bottomCenter,
                    colors: <Color>[
                      widget.backgroundColor.withOpacity(0),
                      widget.backgroundColor,
                      widget.backgroundColor,
                      widget.backgroundColor.withOpacity(0)
                    ],
                  ).createShader(bounds)
                : LinearGradient(colors: [
                    widget.backgroundColor,
                    widget.backgroundColor
                  ]).createShader(bounds);
          },
          child: Container(
            width: widget.horizontal
                ? widget.width
                : widget.showScaleNumbers
                    ? widget.width + numberSpace
                    : widget.width,
            height: widget.horizontal
                ? widget.showScaleNumbers
                    ? widget.height + numberSpace
                    : widget.height
                : widget.height,
            color: widget.backgroundColor,
            child: SingleChildScrollView(
              controller: ctrl,
              physics: _scrollPhysics,
              scrollDirection:
                  widget.horizontal ? Axis.horizontal : Axis.vertical,
              child: Container(
                width: scaleWidth,
                height: scaleHeight,
                padding: EdgeInsets.only(
                    left: paddingLeft,
                    top: paddingTop,
                    right: paddingRight,
                    bottom: paddingBottom),
                child: widget.horizontal
                    ? _horizontalScaleBuilder()
                    : _verticalScaleBuilder(),
              ),
            ),
          ),
        ),
        scaleIndicator()
      ],
    );
  }
}

class ScaleBarIndicator extends StatelessWidget {
  final bool horizontal;
  final double scaleWidth;
  final double scaleHeight;

  const ScaleBarIndicator(
      {Key key,
      @required this.horizontal,
      @required this.scaleWidth,
      @required this.scaleHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: horizontal ? scaleHeight : scaleWidth,
      child: CustomPaint(
        painter: ScaleBarIndicatorPaint(context),
      ),
    );
  }
}

class ScaleBarIndicatorPaint extends CustomPainter {
  final BuildContext context;

  ScaleBarIndicatorPaint(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..color = Theme.of(context).primaryColor;
    Paint circle = Paint()..color = Theme.of(context).scaffoldBackgroundColor;

    Path shadowPath = Path()..addRect(Rect.fromLTRB(-2.5, 0, 2.5, size.height));
    canvas.drawShadow(
        shadowPath, Theme.of(context).scaffoldBackgroundColor, 5, true);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), linePaint);
    canvas.drawCircle(Offset(0, size.height * .5), 8, linePaint);
    canvas.drawCircle(Offset(0, size.height * .5), 5, circle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScalePhysics extends ScrollPhysics {
  final double scaleFriction;

  const ScalePhysics({ScrollPhysics parent, @required this.scaleFriction})
      : super(parent: parent);

  @override
  ScalePhysics applyTo(ScrollPhysics ancestor) {
    return ScalePhysics(
        parent: buildParent(ancestor), scaleFriction: scaleFriction);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (parent == null) return offset;
    return parent.applyPhysicsToUserOffset(position, offset * scaleFriction);
  }

  @override
  double get minFlingVelocity => 1;

  @override
  double get maxFlingVelocity => 8000 * (scaleFriction / 10);
}
