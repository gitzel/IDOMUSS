import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';

class TextCadastro extends StatelessWidget {
  String _frase;
  TextCadastro(this._frase);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: paddingMedium, bottom: paddingSmall),
      child: Text(
        _frase,
        style: TextStyle(color: ColorSys.black, fontSize: fontSizeRegular),
      ),
    );
  }
}
