import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class CadastroScaffold extends StatelessWidget {
  
  List<Widget> children;
  String labelButtonBottomBar;
  void Function() onPressed;

  CadastroScaffold({this.children, this.labelButtonBottomBar, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.topLeft,
        decoration: background,
        child: Padding(
          padding: const EdgeInsets.all(paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
      bottomNavigationBar: FlatButton(
        disabledColor: ColorSys.secundarygray,
        padding: EdgeInsets.all(paddingLarge),
        child: Text(
          labelButtonBottomBar,
          style: TextStyle(color: Colors.white),
        ),
        color: ColorSys.primary,
        onPressed: onPressed,
      ),
    );
  }
}
