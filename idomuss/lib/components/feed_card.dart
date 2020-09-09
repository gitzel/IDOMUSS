import 'package:flutter/material.dart';
import 'package:idomuss/components/feed_details.dart';
import 'package:idomuss/components/feed_name_widget.dart';

class FeedCard extends StatelessWidget {
  String img, nome, servico;
  int curtidas;
  List<int> limite;
  bool premium;

  FeedCard(this.nome, this.curtidas, this.servico, this.limite, this.premium,
      this.img);

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
              Image.network(
                img,
                height:MediaQuery.of(context).size.height * 0.35,
                fit: BoxFit.cover
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FeedDetails(curtidas, servico, limite, premium),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                child: FeedNameWidget(nome),
              )
            ],
          ),
        ),
      ),
    );
  }
}
