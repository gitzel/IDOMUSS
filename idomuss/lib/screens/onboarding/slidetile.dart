import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';

class SlideTile extends StatelessWidget {
  String imagePath, titulo, descricao;

  SlideTile({this.imagePath, this.titulo, this.descricao});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal:20),
            child: Image.asset(imagePath),
          ),
          SizedBox(height: 30,),
          RichText(
            text:TextSpan(
              text: titulo,
              style: TextStyle(
                color: ColorSys.black, 
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',  // tem q instalar a fonte
              ),
            ),
            textAlign: TextAlign.center
          ),
          SizedBox(height: 20,),
          RichText(
            text:TextSpan(
              text: descricao,
              style: TextStyle(
                color: ColorSys.gray, 
                fontFamily: 'Montserrat',  // tem q instalar a fonte
              ),
            ),
            textAlign: TextAlign.center
          ),
        ],
      ),
    );
  }
}