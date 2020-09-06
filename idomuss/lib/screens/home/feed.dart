import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/feed_card.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return StreamBuilder<List<Profissional>>(
      stream: DatabaseService(uid:user.uid).melhoresDaSemana,
      builder: (context, snapshot) {

        if(snapshot.hasData)
          print(snapshot.data);

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
                        child: Text("Localização atual"),
                        flex: 6,
                      )
                    ],
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
                items: <Widget>[
                  FeedCard(
                      'Gustavo', 65, 'Eletricista', [10, 70], false, 'gitzel.jpg'),
                  FeedCard(
                      'Isabela', 64, 'Pedreiro(a)', [40, 120], false, 'isa.jpg'),
                  FeedCard('Amabile', 63, 'Jardineiro(a)', [30, 90], false,
                      'amabile.jpg')
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
