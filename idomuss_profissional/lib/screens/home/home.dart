import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/screens/home/feed.dart';
import 'package:idomussprofissional/screens/home/novosServicos.dart';
import 'package:idomussprofissional/screens/home/profissional_perfil.dart';
import 'package:idomussprofissional/screens/home/ranking.dart';
import 'package:idomussprofissional/services/auth.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index;

  Widget TabSelect() {
    final user = Provider.of<FirebaseUser>(context);

    switch (_index) {
      case 0:
        return Ranking();
        break;
      case 1:
        return Feed();
      case 2:
        return NovosServicos();
      case 3:
        return PerfilPrestador();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _index = 1;
  }

  @override
  Widget build(BuildContext context) {
      final user = Provider.of<FirebaseUser>(context);
    return StreamProvider<Profissional>.value(
        value: AuthService().profissional,
        child: FutureBuilder<bool>(
          future: DatabaseService(uid: user.uid).temNotificacao,
          builder: (context, temNotificacao) {
            if(!temNotificacao.hasData)
              return Scaffold(
                body: LoadPage());

            return Scaffold(
              backgroundColor: ColorSys.gray,
              body: TabSelect(),
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: ColorSys.gray,
                index: _index,
                items: <Widget>[
                  Icon(Icons.assessment, size: 30, color: ColorSys.primary),
                  Icon(Icons.home, size: 30, color: ColorSys.primary),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
  color: !temNotificacao.data? Colors.white : Color(0xFFb71540),
  shape: BoxShape.circle,
                    ),
                    child:Icon(Icons.assignment, size: 30, color: !temNotificacao.data? ColorSys.primary : Colors.white)),
                      
                  Icon(Icons.person, size: 30, color: ColorSys.primary),
                ],
                onTap: _onItemTapped,
              ),
            );
          }
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}
