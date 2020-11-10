import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/screens/home/calendario.dart';
import 'package:idomussprofissional/screens/home/requisicoesServicos.dart';
import 'package:idomussprofissional/screens/home/servicosEmAnalise.dart';
import 'package:provider/provider.dart';

class NovosServicos extends StatefulWidget {
  @override
  _NovosServicosState createState() => _NovosServicosState();
}

class _NovosServicosState extends State<NovosServicos> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return DefaultTabController(
      length: 3,
          child: Scaffold(
            appBar: AppBar(elevation: 0,
            title: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.new_releases),),
                Tab(icon: Icon(Icons.access_time),),
                Tab(icon: Icon(Icons.work),)
              ],
            ),
            titleSpacing: 0,
            ),
            body: Container(
              color: ColorSys.gray,
              child: TabBarView(
                children: [
                  RequisicoesServicos(),
                  AnaliseServicos(),
                  CalendarioServicos()
                ],
              ),
            ),
          ),
    );
  }
}
