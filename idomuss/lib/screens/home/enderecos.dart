import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/screens/configuracoes/listaEnderecos.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/mapaLocalizacao.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class Enderecos extends StatefulWidget {
  LatLng pos;
  Enderecos(this.pos);

  @override
  _EnderecosState createState() => _EnderecosState();
}

class _EnderecosState extends State<Enderecos> {
  String numero;
  TextEditingController _numeroController,
      _complementoController = new TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    numero = "";
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: StreamBuilder<List<Endereco>>(
          stream: DatabaseService(uid: user.uid).enderecosFromCliente,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(paddingSmall),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapaLocalizacao(),
                            ));

                        if (result != null)
                          _getNumero(context, result[0], result[1]);
                      },
                      decoration: textFilled.copyWith(
                        hintText: "Digite seu endereço e número",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  FutureBuilder<Position>(
                      future: getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high),
                      builder: (context, currentPosition) {
                        if (!currentPosition.hasData)
                          return Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: RaisedButton(
                              onPressed: null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LoadPage(),
                              ),
                            ),
                          );

                        return FutureBuilder<List<Placemark>>(
                          future: placemarkFromCoordinates(
                              currentPosition.data.latitude,
                              currentPosition.data.longitude),
                          builder: (context, listPlacemark) {
                            if (!listPlacemark.hasData) return LoadPage();

                            return Padding(
                              padding: const EdgeInsets.all(paddingSmall),
                              child: RaisedButton(
                                  onPressed: () {
                                    _getNumero(
                                        context,
                                        LatLng(currentPosition.data.latitude,
                                            currentPosition.data.longitude),
                                        listPlacemark.data.first.name);
                                  },
                                  padding: EdgeInsets.all(paddingSmall),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                          flex: -1,
                                          child: Icon(
                                            Icons.my_location,
                                            color: Colors.white,
                                          )),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: paddingTiny),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Localização atual",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                listPlacemark
                                                        .data.first.street +
                                                    ", " +
                                                    listPlacemark
                                                        .data.first.subLocality,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          },
                        );
                      }),
                  Padding(
                      padding: const EdgeInsets.all(paddingSmall),
                      child: Text(
                        "Endereços salvos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  snapshot.data == null
                      ? SizedBox.shrink()
                      : ListaEnderecos(snapshot.data, user.uid)
                ],
              ),
            );
          }),
    );
  }

  void _getNumero(context, pos, numero) {
    _numeroController = new TextEditingController(text: numero);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: Text(
                    "Veja se o número da residência está correto",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: fontSizeRegular),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: TextFormField(
                    controller: _numeroController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "Digite o número da residência",
                      prefixIcon: Icon(Icons.search),
                      fillColor: ColorSys.lightGray,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: Text(
                    "Se tiver complemento, pode me falar!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: fontSizeRegular),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: TextFormField(
                    controller: _complementoController,
                    decoration: InputDecoration(
                      hintText: "Ex. Torre XX APT XX",
                      prefixIcon: Icon(Icons.search),
                      fillColor: ColorSys.lightGray,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(paddingSmall),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text("Salvar"),
                        onPressed: _numeroController.text.isEmpty
                            ? null
                            : () {
                                Navigator.pop(context);
                                Navigator.pop(context, [pos, numero]);
                              },
                      ),
                    )),
              ],
            ),
          );
        });
  }
}
