import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';

class BackButton extends StatelessWidget {
  Color color;

  BackButton({this.color = ColorSys.primary});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: color,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
