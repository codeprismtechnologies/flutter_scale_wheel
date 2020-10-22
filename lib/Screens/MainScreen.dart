import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scale_wheel/Screens/FullWheelScreen.dart';
import 'package:scale_wheel/Screens/ScaleScreen.dart';
import 'package:scale_wheel/Screens/SemiWheel.screen.dart';
import 'package:scale_wheel/Screens/VerticalScaleScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CupertinoTabBar cupertinoTabBar = CupertinoTabBar(items: [
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.speedometer,
      ),
      label: "Wheel",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.gauge,
      ),
      label: "Semi Wheel",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.graphic_eq,
      ),
      label: "Scale",
    ),
    BottomNavigationBarItem(
      icon: RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.graphic_eq,
        ),
      ),
      label: "Vertical Scale",
    )
  ]);

  CupertinoTabView cupertinoTabView(int tabIndex) =>
      CupertinoTabView(builder: (_) {
        switch (tabIndex) {
          case 0:
            return FullWheelScreen();
          case 1:
            return SemiWheelScreen();
          case 2:
            return ScaleScreen();
          case 3:
            return VerticalScaleScreen();
          default:
            return FullWheelScreen();
        }
      });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: cupertinoTabBar,
        tabBuilder: (_, tabIndex) => cupertinoTabView(tabIndex));
  }
}
