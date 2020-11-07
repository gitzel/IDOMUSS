import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/servico_item.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/cliente.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/screens/home/home.dart';
import 'package:idomussprofissional/screens/home/infoServico.dart';
import 'package:idomussprofissional/screens/home/ranking.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:provider/provider.dart';

class NovosServicos extends StatefulWidget {
  @override
  _NovosServicosState createState() => _NovosServicosState();
}

class _NovosServicosState extends State<NovosServicos> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: -1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                paddingSmall, paddingExtraLarge, paddingSmall, paddingSmall),
            child: Container(
              width: double.infinity,
              child: RaisedButton(
                color: ColorSys.gray,
                padding: EdgeInsets.all(paddingSmall),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.calendar_today, color: ColorSys.primary),
                    Flexible(
                        child: Text(
                      "Confira as datas dos seus serviços!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: -1,
          child: Padding(
            padding: EdgeInsets.only(left: paddingSmall, bottom: paddingSmall),
            child: Text(
              "Requisições ou novos serviços",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: fontSizeRegular),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ServicoContratado>>(
              stream: DatabaseService(uid: user.uid).servicosPendentes,
              builder: (context, servicosPendentes) {
                if (!servicosPendentes.hasData) return LoadPage();

                if (servicosPendentes.data.isEmpty)
                  return Padding(
                    padding: const EdgeInsets.all(paddingSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Center(
                          child: Text(
                            "Infelizmente, ninguém contatou seus serviços!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeRegular),
                          ),
                        )
                      ],
                    ),
                  );
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: servicosPendentes.data.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return InfoServico(servicosPendentes.data[index]);
                          }));
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(paddingSmall),
                              child: ServicoItem(
                                servicosPendentes.data[index],
                                width: MediaQuery.of(context).size.width -
                                    paddingSmall * 2,
                              ),
                            ),
                            servicosPendentes.data[index].visualizado
                                ? SizedBox.shrink()
                                : Positioned(
                                    left: paddingSmall / 2,
                                    top: paddingSmall / 2,
                                    child: Container(
                                      padding: EdgeInsets.all(paddingTiny),
                                      decoration: BoxDecoration(
                                          color: ColorSys.primary,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        "Novo",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      );
                    });
              }),
        ),
      ],
    );
  }
}
