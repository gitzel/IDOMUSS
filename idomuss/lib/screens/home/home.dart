import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/servico.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/favorite.dart';
import 'package:idomuss/screens/home/notificacoes.dart';
import 'package:idomuss/screens/home/perfil.dart';
import 'package:idomuss/services/auth.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';
import 'package:idomuss/screens/home/feed.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  int _index;

  Widget TabSelect() {
    switch (_index) {
      case 0:
        return Feed();
        break;
      case 1:
        return Favorite();
        break;
      case 2:
        return StreamProvider<List<Servico>>.value(value:  DatabaseService().ListaServicos,
            child:Busca());
        break;
      case 3:
        return Notificacoes();
        break;
      case 4:
        return Perfil();
        break;
    }
  }

  @override
  void initState() {
    _index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Cliente>.value(
        value: AuthService().client,
        child: Scaffold(
          backgroundColor: ColorSys.gray,
          body: SizedBox.expand(child: TabSelect()),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: ColorSys.gray,

            index: _index,
            items: <Widget>[
              Icon(
                Icons.home,
                size: 30,
                color: ColorSys.primary,
              ),
              Icon(Icons.favorite, size: 30, color: ColorSys.primary),
              Icon(Icons.local_mall, size: 30, color: ColorSys.primary),
              Icon(Icons.notifications, size: 30, color: ColorSys.primary),
              Icon(Icons.person, size: 30, color: ColorSys.primary),
            ],
            onTap: _onItemTapped,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}
