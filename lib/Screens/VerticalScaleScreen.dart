import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scale_wheel/Components/ScaleBar.dart';

class VerticalScaleScreen extends StatefulWidget {
  @override
  _VerticalScaleScreenState createState() => _VerticalScaleScreenState();
}

class _VerticalScaleScreenState extends State<VerticalScaleScreen> {
  NeedlesDirection _needlesDirection = NeedlesDirection.btt;
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
                  width: MediaQuery.of(context).size.width - (_scaleWidth + 50),
                  height: viewHeight,
                ),
                Container(
                  width: _scaleWidth + 50,
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
