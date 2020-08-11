import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/screens/home/lista.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class Busca extends StatefulWidget {
  @override
  _BuscaState createState() => _BuscaState();
}

class _BuscaState extends State<Busca> {
  double _crossAxisSpacing = paddingMedium,
      _mainAxisSpacing = 12,
      _aspectRatio = 2.15;
  int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    var width =
        (size - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var height = width / _aspectRatio;
    final servicos = Provider.of<List<String>>(context) ?? [];
    print(servicos);
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: ColorSys.primary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(paddingSmall,
                  2 * paddingExtraLarge, paddingSmall, paddingSmall),
              child: RichText(
                text: new TextSpan(
                  style: new TextStyle(
                      fontSize: fontSizeSubTitle,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(text: 'Buscar'),
                    TextSpan(
                        text: ' serviços',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          75, paddingSmall, paddingSmall, paddingSmall),
                      child: Container(
                        decoration: new BoxDecoration(
                          color: ColorSys.lightGray,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: new TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              hintText: "Digite um nome/serviço"),
                        ),
                      )),
                  Expanded(
                    child: GridView.builder(
                      itemCount: 10,
                      padding: EdgeInsets.all(paddingSmall),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaPrestadores()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.purple[((index) % 9 + 1) * 100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment(-0.7, -0.8),
                              child: Text(
                                "a",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _crossAxisCount,
                        crossAxisSpacing: _crossAxisSpacing,
                        mainAxisSpacing: _mainAxisSpacing,
                        childAspectRatio: _aspectRatio,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
