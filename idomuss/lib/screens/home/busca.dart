import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/servico.dart';
import 'package:idomuss/screens/home/lista.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class Busca extends StatefulWidget {
  @override
  _BuscaState createState() => _BuscaState();
}

class _BuscaState extends State<Busca> with TickerProviderStateMixin {
  double _crossAxisSpacing = paddingMedium,
      _mainAxisSpacing = 12,
      _aspectRatio = 2.15;
  int _crossAxisCount = 2;

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    final user = Provider.of<FirebaseUser>(context);
    var width =
        (size - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var height = width / _aspectRatio;
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
              child: StreamBuilder<List<Servico>>(
                stream: DatabaseService().ListaServicos(_controller.text),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Column(
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
                                controller: _controller,
                              ),
                            )),
                        Expanded(
                          child: GridView.builder(
                            itemCount: snapshot.data.length,
                            padding: EdgeInsets.all(paddingSmall),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ListaPrestadores(snapshot.data[index].nome);
                                  }));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot.data[index].img),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.3),
                                          BlendMode.darken),
                                    ),
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
                                      snapshot.data[index].nome,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              crossAxisSpacing: _crossAxisSpacing,
                              mainAxisSpacing: _mainAxisSpacing,
                              childAspectRatio: _aspectRatio,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return LoadPage();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitDoubleBounce(
          color: ColorSys.primary,
          size: 50.0,
        ),
      ),
    );
  }
}
