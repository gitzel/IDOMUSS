import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:idomuss/connect.dart';
import 'package:idomuss/db/cliente.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final _formKey = GlobalKey<FormState>();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _counter = "";

  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  void _search() {
    setState(() {
      getApi();
    });
  }

  Future getApi() async {
    Cliente teste = new Cliente('0123456','0123456','testeNode1', 'testeNode1@gmail.com', '1237462924', '12/03/1999','Homem', 0, 'oi, sou legal', 'asgdusi.png');

    Connect.deletar(teste, "aeiou");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  _search();
                },
                child: Text('Submit'),
              ),
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
          ],
        ),
      ),
    );
  }
}