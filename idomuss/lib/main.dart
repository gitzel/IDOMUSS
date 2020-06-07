import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/cadastro/add_adress.dart';
import 'package:idomuss/screens/authenticate/sign_in.dart';
import 'package:idomuss/screens/onboarding/onboarding.dart';
import 'package:idomuss/screens/wrapper.dart';
import 'package:idomuss/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
          home: Add_Adress()),
    );
  }
}
