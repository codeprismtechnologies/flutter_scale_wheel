import 'package:flutter/material.dart';
import 'package:scale_wheel/Components/ScaleWheel.dart';

class FullWheelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: ScaleWheel(wheelSize: MediaQuery.of(context).size.width * .9),
      ),
    );
  }
}
