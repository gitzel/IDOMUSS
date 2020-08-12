import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/feed_card.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<int> list = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
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
                    offset: Offset(
                        0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: Icon(Icons.location_on, color: ColorSys.primary,), flex: 1,),
                  Expanded(child: Text("Localização atual"), flex: 6,)
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
              FeedCard('gitzel.jpg'),
              FeedCard('isa.jpg'),
              FeedCard('amabile.jpg')
            ],
          ),
        ],
      ),
    );
  }
}
