import 'dart:math';

import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/screens/home/perfil.dart';
import 'package:idomuss/screens/home/profissional_perfil.dart';

class  ProfissionalItem extends StatefulWidget {

  String nome, img;
  int estrelas;
  bool favoritado, premium;
  double height;
  int colorPremium;
  List limite;

  ProfissionalItem(this.nome, this.estrelas, this.limite, this.img, this.favoritado, this.premium, this.height, {this.colorPremium});

  @override
  _State createState() => _State();
}

class _State extends State<ProfissionalItem> {
  @override
  Widget build(BuildContext context) {
    return
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PerfilPrestador()));
            },
            child: Container(
              height: widget.height * 0.8,
              width: MediaQuery.of(context).size.width -
                  paddingMedium * 2,
              decoration: BoxDecoration(
                  gradient: widget.premium ? LinearGradient(colors: Gradients[widget.colorPremium]) : null,
                  color: !widget.premium ? Colors.white : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.3,
                      blurRadius: 5,
                      offset: Offset(
                          0, 0), // changes position of shadow
                    )
                  ],
                  borderRadius:
                  BorderRadius.all(Radius.circular(10))),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height - widget.height,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  widget.img),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(0)),
                          ),
                        ),
                        flex: 3,
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.nome,
                                style: TextStyle(
                                    color: widget.premium ? Colors.white : ColorSys.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.monetization_on, color: widget.premium? Colors.white : ColorSys.primary,),
                                  Text("R\$" + widget.limite[0].toStringAsFixed(2) + " ~ " + widget.limite[1].toStringAsFixed(2),
                                    style: TextStyle(
                                      color: widget.premium ? Colors.white : ColorSys.black,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: List.generate(widget.estrelas, (index) {
                                  return Icon(
                                    Icons.star,
                                    color: widget.premium ? Colors.white : ColorSys.primary,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                             widget.premium? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Image.asset(
                                    "assets/geral/premium_white.png"),
                              ),
                            ) : SizedBox.shrink(),
                            IconButton(
                              icon: Icon(widget.favoritado? Icons.favorite : Icons.favorite_border, color: widget.premium ? Colors.white : ColorSys.primary,),
                              onPressed: (){
                                setState(() {
                                  widget.favoritado = !widget.favoritado;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          );

  }
}

