import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/servico.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/chat.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class ServicoAndamento extends StatefulWidget {
  @override
  _ServicoAndamentoState createState() => _ServicoAndamentoState();
}

class _ServicoAndamentoState extends State<ServicoAndamento> {
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    final user = Provider.of<FirebaseUser>(context);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: ColorSys.primary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 75,
              padding: EdgeInsets.all(paddingSmall),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: RichText(
                  text: new TextSpan(
                    style: new TextStyle(
                        fontSize: fontSizeSubTitle,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.white),
                    children: [
                      TextSpan(text: 'Serviços'),
                      TextSpan(
                          text: ' em andamento',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height -
                    2 * 75 -
                    2 * AppBar().preferredSize.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorSys.gray,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(75.0)),
                ),
                child: StreamBuilder<List<ServicoContratado>>(
                    stream: DatabaseService(uid: user.uid).proximoServico(),
                    builder: (context, servico) {
                      if (!servico.hasData) return Center(child: LoadPage());

                      if (servico.data.isEmpty)
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(paddingSmall),
                                child: Image.asset(
                                    "assets/geral/no_favorites.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: paddingSmall),
                                child: Text(
                                  "Infelizmente, não há atividade por agora!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeRegular),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(paddingSmall),
                                child: Text(
                                  "Volte aqui quando um serviço estiver próximo de acontecer!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: fontSizeRegular * 0.8),
                                ),
                              ),
                            ],
                          ),
                        );

                      return StreamBuilder<Profissional>(
                          stream: DatabaseService().getProfissional(
                              servico.data.first.uidProfissional),
                          builder: (context, profissional) {
                            if (!profissional.hasData) return LoadPage();

                            return FutureBuilder<List<Placemark>>(
                                future: placemarkFromCoordinates(
                                    servico.data.first.localizacao.latitude,
                                    servico.data.first.localizacao.longitude),
                                builder: (context, localizacao) {
                                  if (!localizacao.hasData) return LoadPage();

                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        paddingSmall,
                                        paddingExtraLarge,
                                        paddingSmall,
                                        paddingLarge),
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: ColorSys.primary,
                                          boxShadow: shadow,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                paddingSmall),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 5),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 10,
                                                      blurRadius: 15,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ]),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    profissional.data.foto),
                                                backgroundColor: Colors.white,
                                                minRadius:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                maxRadius:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            profissional.data.nome,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSizeRegular),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: paddingSmall,
                                                vertical: paddingTiny),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.white,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    localizacao
                                                        .data.first.street,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: paddingSmall,
                                                vertical: paddingTiny),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: -1,
                                                  child: Icon(
                                                    Icons.location_city,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      "${localizacao.data.first.subLocality}, ${localizacao.data.first.subAdministrativeArea} -  ${localizacao.data.first.administrativeArea}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: paddingSmall,
                                                vertical: paddingTiny),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.confirmation_number,
                                                  color: Colors.white,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    "N° ${servico.data.first.numero} - ${servico.data.first.complemento} ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: paddingSmall,
                                                vertical: paddingTiny),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Icon(
                                                    Icons.info,
                                                    color: Colors.white,
                                                  ),
                                                  flex: -1,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8),
                                                    child: Text(
                                                      servico
                                                          .data.first.descricao,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: Colors.deepPurple[700],
                                              width: double.infinity,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                            paddingSmall),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.white,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text(
                                                            formatDate(servico
                                                                .data
                                                                .first
                                                                .data),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Chat(profissional
                                                                          .data),
                                                                ));
                                                          },
                                                          icon: Icon(
                                                            Icons.message,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            Icons.call,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.deepPurple[900],
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            bottom:
                                                                Radius.circular(
                                                                    15))),
                                                child: Center(
                                                    child: Text(
                                                  servico.data.first.situacao,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          fontSizeRegular),
                                                ))),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          });
                    }))
          ],
        ),
      ),
    );
  }
}
