import 'package:flutter/material.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class ConfirmarPedidoTile extends StatelessWidget {
  String titulo, conteudo;
  ConfirmarPedidoTile(this.titulo, this.conteudo);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
          child: Text(titulo,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: fontSizeRegular)),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: paddingSmall, vertical: paddingTiny),
            child: TextFormField(
              initialValue: conteudo,
              readOnly: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ))
      ],
    );
  }
}
