import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:idomuss/components/profissiona_info.dart';
import 'package:idomuss/components/profissional_item.dart';
import 'package:idomuss/components/radial_progress.dart';
import 'package:idomuss/components/rounded_image.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/avaliacao.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/servicos/assinar_servico.dart';
import 'package:idomuss/services/auth.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class PerfilPrestador extends StatefulWidget {
  Profissional profissional;

  PerfilPrestador(this.profissional);

  @override
  _PerfilPrestadorState createState() => _PerfilPrestadorState();
}

class _PerfilPrestadorState extends State<PerfilPrestador> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: StreamBuilder<List<Avaliacao>>(
        stream: DatabaseService(uid: user.uid)
            .listaAvaliacoes(widget.profissional.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                              image: NetworkImage(widget.profissional.foto),
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
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: RadialProgress(
                                    width: 4,
                                    goalCompleted: 0.9,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          widget.profissional.foto),
                                      radius: screen.width * 0.15,
                                    ),
                                  ),
                                ),
                                widget.profissional.vip
                                    ? Positioned(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                60,
                                        top: 0,
                                        child: Image.asset(
                                            "assets/geral/premium_white.png"))
                                    : SizedBox.shrink()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: paddingSmall),
                              child: Container(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    widget.profissional.nome,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: fontSizeSubTitle,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: paddingSmall, vertical: paddingLarge),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
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
                                  widget.profissional.nota == -1
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: Text("Não avaliado"))
                                      : Row(
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
                                                widget.profissional.nota
                                                    .toString(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.profissional.servicosPrestados
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: ColorSys.primary,
                                      ),
                                      Text(
                                        widget.profissional.curtidas.toString(),
                                        style: TextStyle(
                                            fontSize: fontSizeRegular),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(paddingSmall),
                        child: ProfissionalInfo(
                          Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.monetization_on,
                              color: ColorSys.primary,
                            ),
                            Text(
                              "R\$" +
                                  widget.profissional.limite[0]
                                      .toStringAsFixed(2) +
                                  " ~ " +
                                  widget.profissional.limite[1]
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                  color: ColorSys.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                      ),
                      Row(), //TODO - profissional skills),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(paddingSmall),
                              child: Container(
                                width: MediaQuery.of(context).size.width -
                                    paddingSmall * 2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.5,
                                      blurRadius: 10,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data[index].texto),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data[index].data,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(paddingMedium),
                        child: RaisedButton(
                          color: ColorSys.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: ColorSys.primary)),
                          padding: const EdgeInsets.all(paddingSmall),
                          child: Text(
                            "Feche um negócio",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AssinarServico(
                                        widget.profissional.uid,
                                        widget.profissional.nome)));
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }

          return LoadPage();
        },
      ),
    );
  }
}
