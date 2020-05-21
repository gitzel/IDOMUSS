import 'package:flutter/material.dart';

class TextFieldOutline extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  IconData prefixIcon;
  String Function(String) validator;
  void Function(String) onchange;
  TextFieldOutline(
      {this.label,
      this.keyboardType,
      this.prefixIcon,
      this.validator,
      this.onchange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: validator,
      onChanged: onchange,
    );
  }
}
