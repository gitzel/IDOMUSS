import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/components/confirmar_servico_tile.dart';
import 'package:idomuss/components/menu_complemento.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmarServico extends StatefulWidget {

  ServicoContratado servicoContrado;
  String nomeProfissional;
  ConfirmarServico(this.servicoContrado, this.nomeProfissional);

  @override
  _ConfirmarServicoState createState() => _ConfirmarServicoState();
}

class _ConfirmarServicoState extends State<ConfirmarServico> {

  TextEditingController _numeroController, _complementoController;
  
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  String formatEndereco(
      String rua, String bairro, String numero, String complemento) {
    return "${rua}, ${bairro}" +
        (numero.isNotEmpty ? " - ${numero}" : "") +
        (complemento.isNotEmpty ? ", ${complemento}" : "");
  }

  Future<List<Placemark>> getPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Position pos;
    if (prefs.getDouble("latitude") == null) {
      pos = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } else {
      pos = Position(
          latitude: prefs.getDouble("latitude"),
          longitude: prefs.getDouble("longitude"));
    }

    widget.servicoContrado.numero = prefs.getString("numero") ?? "";
    widget.servicoContrado.complemento = prefs.getString("complemento") ?? "";
    widget.servicoContrado.localizacao = GeoPoint(pos.latitude, pos.longitude);

    return placemarkFromCoordinates(pos.latitude, pos.longitude);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _numeroController = new TextEditingController();
    _complementoController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
        ),
        body: FutureBuilder<List<Placemark>>(
            future: getPosition(),
            builder: (context, localizacao) {
              if (!localizacao.hasData) return LoadPage();

              return Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: ColorSys.primary,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(paddingSmall),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: fontSizeSubTitle,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(text: 'Confirmar'),
                              TextSpan(
                                  text: ' informações',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: shadow,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width / 4))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: paddingExtraLarge,
                            ),
                            Expanded(
                              child: ConfirmarPedidoTile(
                                  "Quem?", widget.nomeProfissional),
                            ),
                            Expanded(
                              child: ConfirmarPedidoTile("Quando?",
                                  formatDate(widget.servicoContrado.data)),
                            ),
                            Expanded(
                              child: ConfirmarPedidoTile(
                                  "O quê?", widget.servicoContrado.descricao),
                            ),
                            Expanded(
                              child: ConfirmarPedidoTile(
                                  "Onde?",
                                  formatEndereco(
                                      localizacao.data.first.street,
                                      localizacao.data.first.subLocality,
                                      widget.servicoContrado.numero,
                                      widget.servicoContrado.complemento)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(paddingSmall),
                                child: Container(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    onPressed: () {
                                      if (widget.servicoContrado.numero
                                          .toString()
                                          .isNotEmpty)
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.TOPSLIDE,
                                          title:
                                              "Deseja mesmo contatar este profissional?",
                                          desc:
                                              "Ao pressionar ok, o profissional entrará em contato contigo!",
                                          btnCancelOnPress: () {
                                            widget.servicoContrado.numero = "";
                                            widget.servicoContrado.complemento =
                                                "";
                                          },
                                          btnOkOnPress: () {
                                            DatabaseService(uid: user.uid)
                                                .addServicoContratado(
                                                    widget.servicoContrado);
                                            Navigator.popUntil(context,
                                                (route) => route.isFirst);
                                          },
                                        )..show();
                                      else {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            paddingSmall),
                                                    child: Text(
                                                      "Ops! Por favor, insira o número do local",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              fontSizeRegular),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            paddingSmall),
                                                    child: TextFormField(
                                                      controller:
                                                          _numeroController,
                                                      keyboardType:
                                                          TextInputType
                                                              .datetime,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Digite o número da residência",
                                                        prefixIcon:
                                                            Icon(Icons.search),
                                                        fillColor:
                                                            ColorSys.lightGray,
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          borderSide:
                                                              BorderSide(
                                                            width: 0,
                                                            style: BorderStyle
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            paddingSmall),
                                                    child: Text(
                                                      "Se tiver complemento, pode me falar!",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              fontSizeRegular),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            paddingSmall),
                                                    child: TextFormField(
                                                      controller:
                                                          _complementoController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Ex. Torre XX APT XX",
                                                        prefixIcon:
                                                            Icon(Icons.search),
                                                        fillColor:
                                                            ColorSys.lightGray,
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          borderSide:
                                                              BorderSide(
                                                            width: 0,
                                                            style: BorderStyle
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              paddingSmall),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: RaisedButton(
                                                          child: Text("Salvar"),
                                                          onPressed:
                                                              _numeroController
                                                                      .text
                                                                      .isEmpty
                                                                  ? null
                                                                  : () {
                                                                      widget.servicoContrado
                                                                              .numero =
                                                                          _numeroController
                                                                              .text;
                                                                      widget.servicoContrado
                                                                              .complemento =
                                                                          _complementoController
                                                                              .text;
                                                                      AwesomeDialog(
                                                                        context:
                                                                            context,
                                                                        dialogType:
                                                                            DialogType.WARNING,
                                                                        animType:
                                                                            AnimType.TOPSLIDE,
                                                                        title:
                                                                            "Deseja mesmo contatar este profissional?",
                                                                        desc:
                                                                            "Ao pressionar ok, o profissional entrará em contato contigo!",
                                                                        btnCancelOnPress:
                                                                            () {
                                                                          widget
                                                                              .servicoContrado
                                                                              .numero = "";
                                                                          widget
                                                                              .servicoContrado
                                                                              .complemento = "";
                                                                        },
                                                                        btnOkOnPress:
                                                                            () {
                                                                          DatabaseService(uid: user.uid)
                                                                              .addServicoContratado(widget.servicoContrado);
                                                                          Navigator.popUntil(
                                                                              context,
                                                                              (route) => route.isFirst);
                                                                        },
                                                                      )..show();
                                                                    },
                                                        ),
                                                      )),
                                                ],
                                              );
                                            });
                                      }
                                    },
                                    child: Text("Confirmar"),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
