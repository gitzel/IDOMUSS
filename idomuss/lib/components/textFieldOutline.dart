import 'package:flutter/material.dart';

class TextFieldOutline extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  IconData prefixIcon;
  String Function(String) validator;
  void Function(String) onChanged;
  bool obscureText;
  IconButton suffixIcon;

  TextFieldOutline({
      this.label,
      this.keyboardType,
      this.prefixIcon,
      this.validator,
      this.onChanged,
      this.obscureText,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText == null ? false : obscureText,
      decoration: InputDecoration(
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          labelText: label,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
