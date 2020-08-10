import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idomuss/components/profissional_item.dart';
import 'package:idomuss/components/rounded_image.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class PerfilPrestador extends StatefulWidget {
  @override
  _PerfilPrestadorState createState() => _PerfilPrestadorState();
}

class _PerfilPrestadorState extends State<PerfilPrestador> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Gustavo Lima"),
      ),
      body: Container(
        decoration: BoxDecoration(color: ColorSys.primary),
        child:
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorSys.gray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(75.0)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                ],
              ),
            ),
    ),)
    );
  }
}


