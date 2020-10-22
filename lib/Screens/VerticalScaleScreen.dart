import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scale_wheel/Components/ScaleBar.dart';

class VerticalScaleScreen extends StatefulWidget {
  @override
  _VerticalScaleScreenState createState() => _VerticalScaleScreenState();
}

class _VerticalScaleScreenState extends State<VerticalScaleScreen> {
  NeedlesDirection _needlesDirection = NeedlesDirection.ltr;
  ScaleBase _scaleBase = ScaleBase.base10;
  ScaleMeasurePoint _scaleMeasurePoint = ScaleMeasurePoint.center;
  bool _showMedianNeedles = true;
  int _scaleBaseTimes = 40;
  double _scaleWidth = 150;
  bool _showScaleNumbers = true;
  double _gapBetweenNeedles = 10;
  double _scaleValue = 0;
  double _scaleDistance = 0;
  bool _showIndicator = true;
  bool _fadedEdges = true;
  double _initialScaleValue = 20;
  double _scaleFriction = 1;

  _onValueChange(double scaleValue, double scaleDistance) {
    setState(() {
      _scaleValue = scaleValue;
      _scaleDistance = scaleDistance;
    });
  }

  double _getBase(ScaleBase base) {
    switch (base) {
      case ScaleBase.base12:
        return 12;
      case ScaleBase.base10:
        return 10;
      case ScaleBase.base100:
        return 100;
      case ScaleBase.base1:
      default:
        return 1;
    }
  }

  Container labelContainer(String label) => Container(
        width: double.infinity,
        height: 30,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10),
        child: Text(label),
      );

  Container controlContainer({@required Widget child}) => Container(
        width: double.infinity,
        height: 65,
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(width: double.infinity, child: child),
            ),
            Divider(
              thickness: 1,
              height: 5,
              indent: 5,
              endIndent: 5,
              color: CupertinoColors.systemGrey4,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    double viewHeight = MediaQuery.of(context).size.height -
        (110 +
            MediaQuery.of(context).viewPadding.top +
            MediaQuery.of(context).viewPadding.bottom);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                    "Scale Value: $_scaleValue, Scroll Distance: $_scaleDistance",
                    style: Theme.of(context).textTheme.bodyText1)),
            Row(
              children: [
                Container(
                  color: CupertinoColors.systemGrey6,
                  width: MediaQuery.of(context).size.width - _scaleWidth,
                  height: viewHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Needle Direction
                        labelContainer("Needle Direction: "),
                        controlContainer(
                            child: CupertinoSlidingSegmentedControl(
                          onValueChanged: (value) {
                            setState(() {
                              _needlesDirection = value;
                            });
                          },
                          groupValue: _needlesDirection,
                          children: {
                            NeedlesDirection.ltr: Text("LTR"),
                            NeedlesDirection.rtl: Text("RTL"),
                            NeedlesDirection.ltrc: Text("LTRC"),
                            NeedlesDirection.rtlc: Text("RTLC"),
                          },
                        )),
                        // Scale Measure Point
                        labelContainer("Scale Measure Point: "),
                        controlContainer(
                            child: CupertinoSlidingSegmentedControl(
                          onValueChanged: (value) {
                            setState(() {
                              _scaleMeasurePoint = value;
                            });
                          },
                          groupValue: _scaleMeasurePoint,
                          children: {
                            ScaleMeasurePoint.start: Text("Start"),
                            ScaleMeasurePoint.center: Text("Center"),
                            ScaleMeasurePoint.end: Text("End"),
                          },
                        )),
                        // Scale Base
                        labelContainer("Scale Base: "),
                        controlContainer(
                            child: CupertinoSlidingSegmentedControl(
                          onValueChanged: (value) {
                            setState(() {
                              _scaleBase = value;
                            });
                          },
                          groupValue: _scaleBase,
                          children: {
                            ScaleBase.base1: Text("Base 1"),
                            ScaleBase.base10: Text("Base 10"),
                            ScaleBase.base12: Text("Base 12"),
                            ScaleBase.base100: Text("Base 100")
                          },
                        )),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                // Show Median Needles
                                labelContainer("Show Median Needles: "),
                                controlContainer(
                                    child: CupertinoSwitch(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _showMedianNeedles = value;
                                    });
                                  },
                                  value: _showMedianNeedles,
                                )),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                // Show Indicator
                                labelContainer("Show Indicator: "),
                                controlContainer(
                                    child: CupertinoSwitch(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _showIndicator = value;
                                    });
                                  },
                                  value: _showIndicator,
                                ))
                              ],
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                //Scale Numbers
                                labelContainer("Scale Numbers: "),
                                controlContainer(
                                    child: CupertinoSwitch(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _showScaleNumbers = value;
                                    });
                                  },
                                  value: _showScaleNumbers,
                                ))
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                // Faded Edges
                                labelContainer("Faded Edges"),
                                controlContainer(
                                    child: CupertinoSwitch(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _fadedEdges = value;
                                    });
                                  },
                                  value: _fadedEdges,
                                ))
                              ],
                            )),
                          ],
                        ),
                        // Scale Base Times
                        labelContainer(
                            "Scale Base Times: ${_scaleBaseTimes.toString()}"),
                        controlContainer(
                            child: CupertinoSlider(
                          min: 10,
                          max: 100,
                          onChanged: (double value) {
                            setState(() {
                              if (_initialScaleValue >=
                                  (_scaleBaseTimes.toDouble() *
                                      _getBase(_scaleBase))) {
                                _initialScaleValue = value.roundToDouble() *
                                    _getBase(_scaleBase);
                              }
                              _scaleBaseTimes = value.roundToDouble().toInt();
                            });
                          },
                          value: _scaleBaseTimes.toDouble(),
                          divisions: 9,
                        )),
                        // Initial Position
                        labelContainer(
                            "Initial Position ${_initialScaleValue.roundToDouble()}"),
                        controlContainer(
                            child: CupertinoSlider(
                          min: 0,
                          max:
                              _scaleBaseTimes.toDouble() * _getBase(_scaleBase),
                          onChanged: (double value) {
                            setState(() {
                              _initialScaleValue = value.roundToDouble();
                            });
                          },
                          value: _initialScaleValue,
                          divisions: _scaleBaseTimes,
                        )),
                        // Scale Width
                        labelContainer("Scale Width: $_scaleWidth"),
                        controlContainer(
                            child: CupertinoSlider(
                          min: 50,
                          max: 200,
                          onChanged: (double value) {
                            setState(() {
                              _scaleWidth = value.roundToDouble();
                            });
                          },
                          value: _scaleWidth,
                          divisions: 15,
                        )),
                        // Scale Friction
                        labelContainer("Scale Friction: $_scaleFriction"),
                        controlContainer(
                            child: CupertinoSlider(
                          min: 0.1,
                          max: 1,
                          onChanged: (double value) {
                            setState(() {
                              _scaleFriction =
                                  double.parse(value.toStringAsFixed(2));
                            });
                          },
                          value: _scaleFriction,
                          divisions: 9,
                        )),
                        // Needle Gap
                        labelContainer("Needle Gap: $_gapBetweenNeedles"),
                        controlContainer(child: CupertinoSlider(
                          min: 10,
                          max: 50,
                          onChanged: (double value) {
                            setState(() {
                              _gapBetweenNeedles = value.roundToDouble();
                            });
                          },
                          value: _gapBetweenNeedles,
                          divisions: 4,
                        ))
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _scaleWidth,
                  height: viewHeight,
                  child: ScaleBar(
                    width: _scaleWidth,
                    height: viewHeight,
                    shortNeedleColor: Colors.blueGrey,
                    longNeedleColor: Colors.blueGrey,
                    backgroundColor: Colors.white70,
                    horizontal: false,
                    showMedianNeedles: _showMedianNeedles,
                    scaleBase: _scaleBase,
                    scaleBaseTimes: _scaleBaseTimes,
                    needlesDirection: _needlesDirection,
                    showScaleNumbers: _showScaleNumbers,
                    gapBetweenNeedles: _gapBetweenNeedles,
                    onValueChange: _onValueChange,
                    showIndicator: _showIndicator,
                    fadedEdges: _fadedEdges,
                    measurePoint: _scaleMeasurePoint,
                    initialScaleValue: _initialScaleValue,
                    scaleFriction: _scaleFriction,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
