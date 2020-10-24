import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/models/profissional.dart';

class TopTres extends StatefulWidget {

  List<Profissional> list;

  TopTres(List<Profissional> list){
    switch(list.length){
      case 0: 
        this.list = null;
      break;
      case 1:
        this.list = list.sublist(0, 1);
      break;
      case 2:
      this.list = list.sublist(0, 2);
      break;
      default:
        this.list = list.sublist(0, 3);
    }
  }
  @override
  _TopTresState createState() => _TopTresState();
}

class _TopTresState extends State<TopTres> {

  
  List<Widget> getTops(){
    List<Widget> list = new List<Widget>();
    for(int i = 0; i < widget.list.length; i++){
      list.add(TopTresSpot(widget.list[i], i));
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
   
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: getTops(),
    );
  }
}

class TopTresSpot extends StatelessWidget {
  List<Color> colors = [Colors.amber, Colors.blueGrey, Color(0xFFcd7f32)];

  Profissional prof;
  int index;
  TopTresSpot(this.prof, this.index);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Column(
              children: [
                Container(
                  height: height * 0.1,
                  width: height * 0.1,
                  decoration: BoxDecoration(shape: BoxShape.circle, 
                    border: Border.all(
                          width: 3,
                          color: colors[index]
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 8,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(prof.foto),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    prof.nome.split(' ')[0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Container(
              height: 25,
              width: 25,
              child: CircleAvatar(
                backgroundColor: colors[index],
                foregroundColor: Colors.white,
                child: Text((index + 1).toString() + "º",
                style: TextStyle(
                  fontSize: fontSizeSmall
                ),
                ),
              ),
            )
      ],
    );
  }
}
