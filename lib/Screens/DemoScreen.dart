import 'package:flutter/material.dart';
import 'package:scale_wheel/Components/Wheel.dart';

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scale Wheel Demo"
        ),
      ),
      body: Wheel(),
    );
  }
}
