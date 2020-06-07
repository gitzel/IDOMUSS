import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:idomuss/screens/home/feed.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  int _index;

  final tabs = [];

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
          body: Feed(),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: ColorSys.gray,
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
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
          ),
        ));
  }
}