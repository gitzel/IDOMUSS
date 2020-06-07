import 'package:flutter/material.dart';
import 'package:idomuss/helpers/constantes.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSmall,vertical: paddingExtraLarge),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: RaisedButton.icon(onPressed: (){}, icon: Icon(Icons.location_on) , label: Text("Localização Atual")),
          )
        ],
      ),
    );
  }
}