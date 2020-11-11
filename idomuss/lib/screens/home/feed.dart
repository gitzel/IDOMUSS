import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/components/feed_card.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/enderecos.dart';
import 'package:idomuss/screens/home/mapaLocalizacao.dart';
import 'package:idomuss/screens/home/perfil.dart';
import 'package:idomuss/screens/home/profissional_perfil.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  LatLng pos;
  String numero, complemento;

  @override
  void initState() {
    super.initState();
    numero = "";
    complemento = "";
    _requestPermission();
    _getLocalizacaoFromSharedPreferences();
  }

  _getLocalizacaoFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    numero = prefs.getString("numero") ?? "";
    complemento = prefs.getString("complemento") ?? "";

    pos = prefs.get("latitude") == null
        ? null
        : LatLng(prefs.getDouble("latitude"), prefs.getDouble("longitude"));
  }

  _requestPermission() async {
    LocationPermission status = await checkPermission();
    if (status.index == 0)
      LocationPermission permission = await requestPermission();
  }

  _guardarLocalizacao(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("numero", result[1]);
    await prefs.setString("complemento", result[2]);
    await prefs.setDouble("latitude", pos.latitude);
    await prefs.setDouble("longitude", pos.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, sharedPreferences) {
          return FutureBuilder<Position>(
            future: getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
            builder: (context, position) {
              if (!position.hasData) return LoadPage();

              if (pos == null) {
                pos = LatLng(position.data.latitude, position.data.longitude);
              }

              return FutureBuilder<List<Placemark>>(
                future: placemarkFromCoordinates(pos.latitude, pos.longitude),
                builder: (context, address) {
                  return StreamBuilder<List<Profissional>>(
                      stream: DatabaseService(uid: user.uid)
                          .melhoresDaSemana(pos.latitude, pos.longitude),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return LoadPage();

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    paddingSmall,
                                    paddingLarge * 2,
                                    paddingSmall,
                                    paddingMedium),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
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
                                  child: GestureDetector(
                                    onTap: () async {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Enderecos(
                                                LatLng(pos.latitude,
                                                    pos.longitude)),
                                          ));
                                      setState(() {
                                        if (result != null) {
                                          pos = result[0];
                                          numero = result[1];
                                          complemento = result[2];
                                          _guardarLocalizacao(result);
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Icon(
                                            Icons.location_on,
                                            color: ColorSys.primary,
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: paddingSmall),
                                            child: Text(address
                                                    .data.first.street +
                                                ", " +
                                                address.data.first.subLocality +
                                                " - " +
                                                (numero.isEmpty
                                                    ? address.data.first.name
                                                    : numero)),
                                          ),
                                          flex: 6,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: paddingSmall, bottom: paddingLarge),
                                child: Text(
                                  'Destaques da semana',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: ColorSys.black),
                                ),
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                    height: MediaQuery.of(context).size.width),
                                items: List.generate(snapshot.data.length,
                                    (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PerfilPrestador(
                                                    snapshot.data[index]),
                                          ));
                                    },
                                    child: FeedCard(
                                        snapshot.data[index].nome,
                                        snapshot.data[index].curtidas,
                                        snapshot.data[index].nomeServico,
                                        snapshot.data[index].limite,
                                        snapshot.data[index].vip,
                                        snapshot.data[index].foto),
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                      });
                },
              );
            },
          );
        });
  }
}
