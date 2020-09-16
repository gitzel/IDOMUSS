import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/screens/home/profissional_perfil.dart';
import 'package:idomussprofissional/services/auth.dart';
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
        break;
      case 1:
        return RaisedButton(onPressed: (){
          AuthService().signOut();
        },);
      case 2:
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
    return StreamProvider<Profissional>.value(
        value: AuthService().profissional,
        child: Scaffold(
          backgroundColor: ColorSys.gray,
          body: SizedBox.expand(child: TabSelect()),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: ColorSys.gray,
            index: _index,
            items: <Widget>[
              Icon(Icons.score, size: 30, color: ColorSys.primary),
              Icon(Icons.home, size: 30, color: ColorSys.primary),
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
