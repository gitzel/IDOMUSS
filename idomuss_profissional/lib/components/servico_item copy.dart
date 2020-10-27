import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';

class ServicoEspecialItem extends StatefulWidget {
  ServicoContratado servico;

  ServicoEspecialItem(this.servico);

  @override
  _State createState() => _State();
}

class _State extends State<ServicoEspecialItem> with TickerProviderStateMixin {
  //Animation
  Animation<double> _animation;

//Animation Controller
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void onDispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ColorSys.primary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: ColorSys.primary.withOpacity(0.5),
                      blurRadius: _animation.value,
                      spreadRadius: _animation.value)
                ]),
            padding: EdgeInsets.all(paddingSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: -1,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: shadow,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/geral/bg.png"),
                      radius: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: paddingSmall),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Maria do Carmo",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: fontSizeSmall,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Rua Maria das Flores" + ", 330, AP 18",
                                      style: TextStyle(
                                          fontSize: fontSizeSmall / 1.5,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.timelapse,
                                color: Colors.white,
                                size: fontSizeSmall,
                              ),
                              Text(
                                "15h30",
                                style: TextStyle(
                                    fontSize: fontSizeSmall,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
