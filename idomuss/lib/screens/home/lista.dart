import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/profissional_item.dart';
import 'package:idomuss/components/rounded_image.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class ListaPrestadores extends StatefulWidget {

  String nomeServico;

  ListaPrestadores(this.nomeServico);

  @override
  _ListaPrestadoresState createState() => _ListaPrestadoresState();
}

class _ListaPrestadoresState extends State<ListaPrestadores> {
  
  static double height;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    height = MediaQuery.of(context).size.height * 0.2;

    int indiceColor = 0;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Container(
          color: ColorSys.primary,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ColorSys.gray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(75.0)),
            ),
            child: StreamBuilder<List<Profissional>>(
              stream: DatabaseService(uid:user.uid).profissionaisCategoria(widget.nomeServico),
              builder: (context, snapshot) {

                if(!snapshot.hasData) 
                  return LoadPage();
                
                List<Profissional> vips = new List<Profissional>();
                List<Profissional> profissionais = snapshot.data;
                if(profissionais.isNotEmpty)
                profissionais.removeWhere((element) {
                  if (element.vip) vips.add(element);
                  return element.vip;
                }); 

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 75.0,
                    ),
                    vips.length <= 0
                        ? SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(left: paddingSmall),
                            child: Text(
                              "Premium",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeRegular),
                            ),
                          ),
                    vips.length <= 0
                        ? SizedBox.shrink()
                        : Container(
                            height: height,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vips.length,
                              itemBuilder: (context, index) {
                                if (indiceColor > 5) indiceColor = 0;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: paddingMedium,
                                      vertical: paddingSmall),
                                  child: ProfissionalItem(
                                    vips[index],
                                    vips[index].favoritado,
                                    true,
                                    height,
                                    (){
                                if(!vips[index].favoritado)
                                        DatabaseService(uid: user.uid).addFavoritos(vips[index].uid).then((value) {
                                          setState(() {
                                            vips[index].favoritado = !vips[index].favoritado;
                                          });
                                        });
                                      else
                                        DatabaseService(uid: user.uid).removerFavoritos(vips[index].uid).then((value) {
                                          setState(() {
                                            vips[index].favoritado = !vips[index].favoritado;
                                          });
                                        });
                              },
                                    colorPremium: indiceColor++,
                                    uidUser: user.uid,
                                  ),
                                );
                              },
                            ),
                          ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: profissionais.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingMedium, vertical: paddingSmall),
                            child: ProfissionalItem(
                              profissionais[index],
                              profissionais[index].favoritado,
                              false,
                              height,
                              (){
                                if(!profissionais[index].favoritado)
                                        DatabaseService(uid: user.uid).addFavoritos(profissionais[index].uid).then((value) {
                                          setState(() {
                                            profissionais[index].favoritado = !profissionais[index].favoritado;
                                          });
                                        });
                                      else
                                        DatabaseService(uid: user.uid).removerFavoritos(profissionais[index].uid).then((value) {
                                          setState(() {
                                            profissionais[index].favoritado = !profissionais[index].favoritado;
                                          });
                                        });
                              },
                              uidUser: user.uid,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              }
            ),
          ),
        ));
  }
}
