import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scale_wheel/Components/ScaleBar.dart';

class ScaleScreen extends StatefulWidget {
  @override
  _ScaleScreenState createState() => _ScaleScreenState();
}

class _ScaleScreenState extends State<ScaleScreen> {
  NeedlesDirection _needlesDirection = NeedlesDirection.btt;
  ScaleBase _scaleBase = ScaleBase.base10;
  ScaleMeasurePoint _scaleMeasurePoint = ScaleMeasurePoint.center;
  bool _showMedianNeedles = true;
  int _scaleBaseTimes = 40;
  double _scaleHeight = 100;
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
    switch(base){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Scale Value: $_scaleValue, Scroll Distance: $_scaleDistance",
                    style: Theme.of(context).textTheme.bodyText1)),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ScaleBar(
                width: MediaQuery.of(context).size.width - 40,
                height: _scaleHeight,
                shortNeedleColor: Colors.blueGrey,
                longNeedleColor: Colors.blueGrey,
                backgroundColor: Colors.white70,
                horizontal: true,
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
            Container(
              height: MediaQuery.of(context).size.height - ((_showScaleNumbers ? 175 : 155) + _scaleHeight + MediaQuery.of(context).viewPadding.bottom),
              color: CupertinoColors.systemGrey6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Needles Direction: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoSlidingSegmentedControl(
                              onValueChanged: (value) {
                                setState(() {
                                  _needlesDirection = value;
                                });
                              },
                              groupValue: _needlesDirection,
                              children: {
                                NeedlesDirection.ttb: Text("TTB"),
                                NeedlesDirection.btt: Text("BTT"),
                                NeedlesDirection.ttbc: Text("TTBC"),
                                NeedlesDirection.bttc: Text("BTTC"),
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scale Measure Point: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scale Base: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Show Median Needles: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CupertinoSwitch(
                                        onChanged: (bool value) {
                                          setState(() {
                                            _showMedianNeedles = value;
                                          });
                                        },
                                        value: _showMedianNeedles,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Show Indicator: ",
                                      textAlign: TextAlign.right,
                                    ),
                                  )),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoSwitch(
                                      onChanged: (bool value) {
                                        setState(() {
                                          _showIndicator = value;
                                        });
                                      },
                                      value: _showIndicator,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scale Numbers: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CupertinoSwitch(
                                        onChanged: (bool value) {
                                          setState(() {
                                            _showScaleNumbers = value;
                                          });
                                        },
                                        value: _showScaleNumbers,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Faded Edges: ",
                                      textAlign: TextAlign.right,
                                    ),
                                  )),
                              Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CupertinoSwitch(
                                        onChanged: (bool value) {
                                          setState(() {
                                            _fadedEdges = value;
                                          });
                                        },
                                        value: _fadedEdges,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scale Base Times: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(_scaleBaseTimes.toString()),
                                Expanded(
                                  child: CupertinoSlider(
                                    min: 10,
                                    max: 100,
                                    onChanged: (double value) {
                                      setState(() {
                                        if(_initialScaleValue >= (_scaleBaseTimes.toDouble() * _getBase(_scaleBase))){
                                          _initialScaleValue = value.roundToDouble() * _getBase(_scaleBase);
                                        }
                                        _scaleBaseTimes = value.roundToDouble().toInt();
                                      });
                                    },
                                    value: _scaleBaseTimes.toDouble(),
                                    divisions: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Initial Position: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(_initialScaleValue.toString()),
                                Expanded(
                                  child: CupertinoSlider(
                                    min: 0,
                                    max: _scaleBaseTimes.toDouble() * _getBase(_scaleBase),
                                    onChanged: (double value) {
                                      setState(() {
                                        _initialScaleValue = value.roundToDouble();
                                      });
                                    },
                                    value:_initialScaleValue,
                                    divisions: _scaleBaseTimes,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scale Height: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(_scaleHeight.toString()),
                                Expanded(
                                  child: CupertinoSlider(
                                    min: 50,
                                    max: 200,
                                    onChanged: (double value) {
                                      setState(() {
                                        _scaleHeight = value.roundToDouble();
                                      });
                                    },
                                    value: _scaleHeight,
                                    divisions: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )    ,          Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scale Friction: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(_scaleFriction.toString()),
                                Expanded(
                                  child: CupertinoSlider(
                                    min: 0.1,
                                    max: 1,
                                    onChanged: (double value) {
                                      setState(() {
                                        _scaleFriction = double.parse(value.toStringAsFixed(2));
                                      });
                                    },
                                    value: _scaleFriction,
                                    divisions: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Needles Gap: ",
                                textAlign: TextAlign.right,
                              ),
                            )),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(_gapBetweenNeedles.toString()),
                                Expanded(
                                  child: CupertinoSlider(
                                    min: 10,
                                    max: 50,
                                    onChanged: (double value) {
                                      setState(() {
                                        _gapBetweenNeedles = value.roundToDouble();
                                      });
                                    },
                                    value: _gapBetweenNeedles,
                                    divisions: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
