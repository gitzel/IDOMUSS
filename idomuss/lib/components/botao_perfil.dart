import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class ButtonProfile extends StatelessWidget {
  String label;
  IconData icon;
  Function onPressed;
  ButtonProfile(this.label, this.icon, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Icon(
              icon,
              color: ColorSys.primary,
            )
          ],
        ),
        padding: const EdgeInsets.all(paddingSmall),
        color: Colors.white,
        onPressed: onPressed,
        highlightColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.white)));
  }
}
