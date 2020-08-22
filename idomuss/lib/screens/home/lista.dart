import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/profissional_item.dart';
import 'package:idomuss/components/rounded_image.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class ListaPrestadores extends StatefulWidget {
  @override
  _ListaPrestadoresState createState() => _ListaPrestadoresState();
}

class _ListaPrestadoresState extends State<ListaPrestadores> {

  dynamic user, favoritos;
  bool teste = false;
  static double height;

  Future<dynamic> getData() async {
    favoritos = await DatabaseService(uid: user.uid).profissionaisPreferidos;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    height = MediaQuery.of(context).size.height * 0.2;
    final profissionais = Provider.of<List<Profissional>>(context) ?? [];

    List vips = new List<Profissional>();

    profissionais.removeWhere((element) {
      if(element.vip)
        vips.add(element);
      return element.vip;
    });

    print(favoritos);
    int indiceColor = 0;
    return Scaffold(
      appBar: AppBar(elevation: 0,),
        body: Container(
          color: ColorSys.primary,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ColorSys.gray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(75.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 75.0,),
                vips.length <= 0? SizedBox.shrink() : Padding(
                  padding: const EdgeInsets.only(left: paddingSmall),
                  child: Text(
                    "Premium",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeRegular),
                  ),
                ),
                vips.length <= 0? SizedBox.shrink() :Container(
                  height: height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vips.length,
                    itemBuilder: (context, index) {
                      if(indiceColor > 5)
                        indiceColor = 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: paddingMedium,
                            vertical: paddingSmall),
                        child: ProfissionalItem(vips[index].nome, vips[index].nota.round(), vips[index].limite, vips[index].foto ,false, true, height, colorPremium: indiceColor++,),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: profissionais.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: paddingMedium,
                            vertical: paddingSmall),
                        child: ProfissionalItem(profissionais[index].nome, profissionais[index].nota.round(), profissionais[index].limite, profissionais[index].foto ,false, false, height, ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}