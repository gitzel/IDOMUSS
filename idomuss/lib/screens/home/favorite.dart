import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorSys.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(paddingSmall,
                2 * paddingExtraLarge, paddingSmall, paddingSmall),
            child: Text(
              "Favoritos",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeSubTitle,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 226.0,
            decoration: BoxDecoration(
              color: ColorSys.gray,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Image.asset("assets/geral/no_favorites.png")),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      paddingSmall, paddingMedium, paddingSmall, paddingSmall),
                  child: Text(
                    "Você ainda não favoritou algum profissional!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: Text(
                    "Selecione o icone central para conhecer os melhores trabalhadores perto de você!",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
