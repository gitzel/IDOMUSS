import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/screens/home/client_list.dart';
import 'package:idomuss/services/auth.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Cliente>.value(
        value: AuthService().client,
        child: Scaffold(
          backgroundColor: Colors.pink[200],
          appBar: AppBar(
            title: Text('Idomuss'),
            backgroundColor: Colors.pink[500],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                onPressed: () async {
                  await _auth.signOut();
                },
                label: Text('logout'),
              )
            ],
          ),
        ));
  }
}
