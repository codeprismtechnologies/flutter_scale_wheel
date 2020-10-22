import 'package:flutter/material.dart';
import 'package:scale_wheel/Screens/MainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MainScreen(),
    );
  }
}


class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Color(0xff007cfa),
    accentColor: Color(0xff454545),
    // Define the default font family.
    fontFamily: 'Roboto',
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 18.0),
      bodyText2: TextStyle(fontSize: 14.0),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Color(0xff007cfa),
    accentColor: Color(0xff454545),
    // Define the default font family.
    fontFamily: 'Roboto',
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 18.0),
      bodyText2: TextStyle(fontSize: 14.0),
    ),
  );


}