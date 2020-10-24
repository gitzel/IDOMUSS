import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldOutline extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  IconData prefixIcon;
  String Function(String) validator;
  void Function(String) onChanged;
  void Function(String) onSaved;
  bool obscureText;
  IconButton suffixIcon;
  String hint;
  List<TextInputFormatter> inputFormatter;
  TextCapitalization textCapitalization;
  int maxLine;
  TextEditingController controller;

  TextFieldOutline(
      {this.label,
      this.keyboardType,
      this.prefixIcon,
      this.validator,
      this.onChanged,
      this.obscureText,
      this.suffixIcon,
      this.hint,
      this.inputFormatter,
      this.textCapitalization = TextCapitalization.none,
      this.maxLine = 1,
      this.controller,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText == null ? false : obscureText,
        decoration: InputDecoration(
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            labelText: label,
            suffixIcon: suffixIcon,
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: validator,
        onChanged: onChanged,
        inputFormatters: inputFormatter,
        textCapitalization: textCapitalization,
        maxLines: maxLine,
        controller: controller,
        onSaved: onSaved);
  }
}
