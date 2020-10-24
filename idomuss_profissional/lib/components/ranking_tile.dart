import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/models/profissional.dart';

class RankingTileWidget extends StatelessWidget {
  int posicao;
  Profissional prof;
  RankingTileWidget(this.posicao, this.prof);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: paddingExtraLarge, vertical: paddingTiny),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height)),
          color: ColorSys.primary.withOpacity(1 / posicao * 0.8),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(posicao.toString() + "º"),
              backgroundColor: ColorSys.primary,
              foregroundColor: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                prof.nome,
                style: TextStyle(
                  color: ColorSys.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
