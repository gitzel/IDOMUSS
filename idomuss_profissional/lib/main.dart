import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/screens/wrapper.dart';
import 'package:idomussprofissional/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
          theme: ThemeData(
              accentColor: ColorSys.primary,
              primaryColor: ColorSys.primary,
              splashColor: Colors.white10,
              fontFamily: 'Montserrat'),
          debugShowCheckedModeBanner: false,
          home: Wrapper()),
    );
  }
}
