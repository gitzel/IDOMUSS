import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/components/feed_card.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
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

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  LatLng pos;
  String endereco = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    
    return FutureBuilder<Position>(
          future: getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation),
          builder: (context, position) {
            
            if(!position.hasData)
              return LoadPage();

            return FutureBuilder<List<Placemark>>(
              future: placemarkFromCoordinates(position.data.latitude, position.data.longitude),
              builder: (context, location) {

                if(!location.hasData)
                  return LoadPage();

                return StreamBuilder<List<Profissional>>(
                   stream: DatabaseService(uid:user.uid).melhoresDaSemana(position.data.latitude, position.data.longitude),
                    builder: (context, snapshot) {

                      if(!snapshot.hasData)
                        return LoadPage();

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                paddingSmall, paddingLarge * 2, paddingSmall, paddingMedium),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 10,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Enderecos(LatLng(position.data.latitude, position.data.longitude), location.data.first),
                                    ));
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
                                      child: Text(location.data[0].street + ", " + location.data[0].subAdministrativeArea),
                                      flex: 6,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: paddingSmall, bottom: paddingLarge),
                            child: Text(
                              'Destaques da semana',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: ColorSys.black),
                            ),
                          ),
                          CarouselSlider(
                            options: CarouselOptions(height: MediaQuery.of(context).size.width),
                            items: List.generate(snapshot.data.length, (index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PerfilPrestador(snapshot.data[index]),
                                              ));
                                },
                                  child: FeedCard(
                                    snapshot.data[index].nome,  snapshot.data[index].curtidas,  snapshot.data[index].nomeServico,  snapshot.data[index].limite,  snapshot.data[index].vip,  snapshot.data[index].foto),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }
                );
              }
            );
          }
    );
  }
}
