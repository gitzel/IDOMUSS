import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class Notificacoes extends StatefulWidget {
  @override
  _NotificacoesState createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
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
            child: RichText(
              text: TextSpan(
                style:  TextStyle(
                    fontSize: fontSizeSubTitle,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(text: 'Serviços'),
                  TextSpan(
                      text: ' pendentes',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
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
                Center(child: Image.asset("assets/geral/no_services.png")),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      paddingSmall, paddingMedium, paddingSmall, paddingSmall),
                  child: Text(
                    "Selecione para conhecer os melhores trabalhadores perto de você!",
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
