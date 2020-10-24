import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/TopTres.dart';
import 'package:idomussprofissional/components/ranking_tile.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:provider/provider.dart';

class PrimitiveWrapper {
  var value;
  PrimitiveWrapper(this.value);
}

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    PrimitiveWrapper posicao = new PrimitiveWrapper(1);
    return FutureBuilder<Profissional>(
      future: DatabaseService(uid: user.uid).getProfissional(),
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          return LoadPage();
        return StreamBuilder<List<Profissional>>(
        stream: DatabaseService(uid: user.uid).ranking(snapshot.data, posicao: posicao, distance: 1000000),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return LoadPage();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: -1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: paddingSmall,
                        right: paddingSmall,
                        top: paddingExtraLarge,
                        bottom: paddingSmall),
                    child: Container(
                      width: double.infinity,
                      decoration: box.copyWith(color: ColorSys.primary),
                      padding: EdgeInsets.all(paddingSmall),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Sua posição atual na região",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 10,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    posicao.value.toString()+ "°",
                                    style: TextStyle(
                                      color: ColorSys.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all( paddingSmall),
                  child: Text("Os 3 melhores",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeRegular
                  ),),
                ),
                Expanded(
                  flex: -1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                    child: TopTres(snapshot.data),
                  ),
                ),
                snapshot.data.length <= 3? SizedBox.shrink() : Expanded(
                  child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return RankingTileWidget(index + 4, snapshot.data[index + 3]);
                      },
                      itemCount: min(7, snapshot.data.length - 3)),
                ),
                Expanded(
                  flex: -1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingSmall, vertical: paddingMedium),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: ColorSys.gray,
                        padding: EdgeInsets.all(paddingSmall),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.assignment, color: ColorSys.primary),
                            Flexible(
                                child: Text(
                              "Veja como anda os serviços!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
