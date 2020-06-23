import 'package:flutter/material.dart';
import 'package:idomuss/components/feed_details.dart';
import 'package:idomuss/components/feed_name_widget.dart';

class FeedCard extends StatelessWidget {

  String img;

  FeedCard(this.img){
    img = this.img;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/geral/' + img,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FeedDetails(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                child: FeedNameWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
