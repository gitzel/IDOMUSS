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
                paddingSmall, paddingExtraLarge, paddingSmall, paddingMedium),
            child: TextFormField(),
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
            items: <Widget>[FeedCard(), FeedCard()],
          ),
        ],
      ),
    );
  }
}
