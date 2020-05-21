import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/sign_in.dart';
import 'package:idomuss/screens/wrapper.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          accentColor: ColorSys.primary,
          primaryColor: ColorSys.primary,
          splashColor: Colors.white10
        ),
        home: Wrapper()
    );
  }
}



