import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  String value;
  String groupValue;
  void Function(String) onChanged;

  RadioButton({this.value, this.groupValue, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio(value: value, groupValue: groupValue, onChanged: onChanged),
        Text(value)
      ],
    );
  }
}
