import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:idomussprofissional/components/profissiona_info.dart';
import 'package:idomussprofissional/components/radial_progress.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/avaliacao.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:provider/provider.dart';

class PerfilPrestador extends StatefulWidget {
  @override
  _PerfilPrestadorState createState() => _PerfilPrestadorState();
}

class _PerfilPrestadorState extends State<PerfilPrestador> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final user = Provider.of<FirebaseUser>(context);

    return StreamBuilder<Profissional>(
        stream: DatabaseService(uid: user.uid).profissional,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LoadPage();

          return Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data.foto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: ColorSys.primary.withOpacity(0.6),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: RadialProgress(
                              width: 4,
                              goalCompleted: 0.9,
                              child: CircleAvatar(
                                backgroundImage: snapshot.data.foto != null
                                    ? NetworkImage(snapshot.data.foto)
                                    : null,
                                backgroundColor: Colors.white,
                                child: snapshot.data.foto == null
                                    ? LoadPage()
                                    : null,
                                radius: screen.width * 0.15,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(paddingSmall),
                                child: Text(
                                  snapshot.data.nome,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSizeSubTitle,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              !snapshot.data.vip
                                  ? SizedBox.shrink()
                                  : Image.asset(
                                      "assets/geral/premium_white.png",
                                    )
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProfissionalInfo(
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: ColorSys.primary,
                                      ),
                                      Text(
                                        snapshot.data.nota.toString(),
                                        style: TextStyle(
                                            fontSize: fontSizeRegular),
                                      )
                                    ]),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProfissionalInfo(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data.servicosPrestados
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorSys.black,
                                        fontSize: fontSizeRegular,
                                      ),
                                    ),
                                    Text(
                                      "serviços",
                                      style: TextStyle(
                                        color: ColorSys.black,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProfissionalInfo(
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: ColorSys.primary,
                                    ),
                                    Text(
                                      snapshot.data.curtidas.toString(),
                                      style:
                                          TextStyle(fontSize: fontSizeRegular),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingSmall),
                      child: ProfissionalInfo(Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: ColorSys.primary,
                          ),
                          Text(
                            "R\$" +
                                snapshot.data.limite[0].toStringAsFixed(2) +
                                " ~ " +
                                snapshot.data.limite[1].toStringAsFixed(2),
                            style: TextStyle(
                                color: ColorSys.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                    ),
                    Row(), //TODO - profissional skills),
                  ],
                ),
              )
            ],
          );
        });
  }
}
