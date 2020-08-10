import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idomuss/components/profissional_item.dart';
import 'package:idomuss/components/rounded_image.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class ListaPrestadores extends StatefulWidget {
  @override
  _ListaPrestadoresState createState() => _ListaPrestadoresState();
}

class _ListaPrestadoresState extends State<ListaPrestadores> {

  bool teste = false;
  static double height;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Marceneiros"),
      ),
      body: Container(
        decoration: BoxDecoration(color: ColorSys.primary),
        child:
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorSys.gray,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(75.0)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 75.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: paddingSmall),
                        child: Text(
                          "Premium",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSizeRegular),
                        ),
                      ),
                      Container(
                        height: height,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: paddingMedium,
                                vertical: paddingSmall),
                              child: ProfissionalItem("Gustavo Lima", 5, false, true, height ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8 - 200,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: paddingMedium,
                                  vertical: paddingSmall),
                              child: ProfissionalItem("Gustavo Lima", 4 - index, false, false,height),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
        ),
    );
  }
}


